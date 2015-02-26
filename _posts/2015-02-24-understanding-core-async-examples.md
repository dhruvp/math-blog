---
layout: post
title: Understanding Core Async vs. Events and Callbacks
---

Introduction
------------

If you read David Nolen's [blog](http://swannodette.github.io/), you'll notice he frequently extolls the virtues of Core.Async as opposed to events and callbacks. For a while, I haven't quite understood why core.async and Go style concurrency is a big deal. So I went over to his blog and read this [post](http://swannodette.github.io/2013/07/12/communicating-sequential-processes/) to get a better idea. The below is my attempt to break down his example and contrast it to what you would do in traditional eventing to finally understand why Core.Async and Go Channels are a big deal.


Diving into Core.Async
======================

Core.Async, if you haven't seen it before, is essentially a library for Clojure that gives you access to the concurrency pattern implemented in Go. To read more about it, see [this](http://clojure.com/blog/2013/06/28/clojure-core-async-channels.html). Moreover, there's an awesome talk on the matter you can check out <a href="http://www.infoq.com/presentations/clojure-core-async" target="_blank">here</a>.


The main idea is that core.async emphasizes using shared Queues as the underlying way for different processes to communicate. Each process just places its message onto the queue and anyone interested in the message, grabs the queue and reads from it. What could be more simple?

Well it's not quite that simple. Say we have two processes, a Caller, and a Listener. The Caller keeps throwing out new things onto the queue, and the Listener is listening to new things on this queue. How would the listener know when to listen to the queue and pick new things off it? Naively, it would have a while loop where it just keeps checking the size of the queue right? We obviously don't want this as it would block the hell out of our program! Both Go and Core.Async solve this problem using Go routines which essentially are light weight threads that run asynchronously. When Listener listens to a queue from within a go routine, it parks the go routine and returns execution to the main thread UNTIL there's something to get from the queue. This way you're not blocking AND you know when stuff comes off the queue. BOOM.

Diving into David Nolen's example
=================================

In David Nolen's [blog post](http://swannodette.github.io/2013/07/12/communicating-sequential-processes/), he starts off with an example that he says should make you "fall out of your chair". I honestly did not fall out of my chair at first because I didn't understand it! So I'm now going to break it down and say WHY what he's doing is interesting and what's cool about it. In his example, Nolen creates 3 independent processes fire events of at different rates. He then creates a fourth process that collects the events from these three processes and presents them to the user. You should just go check it out because it's best understood by seeing it. His code is here for reference.


{% highlight clojure %}
(def c (chan))

(defn render [q]
  (apply str
    (for [p (reverse q)]
      (str "<div class='proc-" p "'>Process " p "</div>"))))

(go (while true (<! (timeout 250)) (>! c 1)))
(go (while true (<! (timeout 1000)) (>! c 2)))
(go (while true (<! (timeout 1500)) (>! c 3)))

(defn peekn
  "Returns vector of (up to) n items from the end of vector v"
  [v n]
  (if (> (count v) n)
    (subvec v (- (count v) n))
    v))

(let [el  (by-id "ex0")
      out (by-id "ex0-out")]
  (go (loop [q []]
        (set-html! out (render q))
        (recur (-> (conj q (<! c)) (peekn 10))))))
{% endhighlight %}

Nolen immediately says that, when done without any mutability, "[this] should seem impossible for those familiar with JavaScript)". Let's find out why!

We first recreate Nolen's render and peek functions in JS. They're simple enough!

{% highlight js %}
render = function (q) {
  return str.join(
    q.map(function (processNumber) {
      return "<div class='proc-" + processNumber + "'>Process " + processNumber + "</div>";
    }));
};

peek = function (v, n) {
  if (v.length > n) {
    return v.slice(v.length-n,v.length-1);
  } else {
    return v;
  }
};
{% endhighlight %}

Now let's focus on the main concept. We now need to create three processes that fire off events at different rates and somehow collect them all. I'm going to start by recreating the three independent processes that fire at different rates and place their events onto some sort of list. This is easy enough with callbacks:

{% highlight js %}
subscribeToProcess1 = function (callback) {
  window.setTimeout(function () {
    callback(1);
  }, 250);
};
{% endhighlight %}


And likewise for the other processes.

{% highlight js %}
subscribeToProcess2 = function (callback) {
  window.setTimeout(function () {
    callback(2);
  }, 1000);
};

subscribeToProcess3 = function (callback) {
  window.setTimeout(function () {
    callback(3);
  }, 1500);
};
{% endhighlight %}

Ok now that I have these processes set up, let me call them. I'm going to create an array to collect all the events.

{% highlight js %}
var collector = [];

callback = function (event) {
  collector.push(event);
}

subscribeToProcess1(callback);
subscribeToProcess2(callback);
subscribeToProcess3(callback);
{% endhighlight %}

## Processing And Rendering ##

If I'm to proceed. I need to do something like what Nolen does here:

{% highlight clojure %}
(go (loop [q []]
      (set-html! out (render q))
      (recur (-> (conj q (<! c)) (peekn 10)))))
{% endhighlight %}

Now I need to just get the last 10 events and render them. In accordance with Nolen's solution, I'll make sure that the array I pass to peek and render isn't mutated by anything else.

{% highlight js %}
callback = fn (event) {
  render(peek(collector.concat([event]), 10));
  collector.push(event);
};
{% endhighlight %}

This does indeed works like Nolen's example. Whenever one of my processes fires an event, it will add the event to the collector, and then render and peek will be called on the collector to display the values. And indeed, the array passed in to peek and render will not be mutated.

Note that Nolen, much like us, uses mutable state to collect the events from the separate processes. A channel is indeed an example shared mutable state!

So what's the big deal?
======================================

It seems like we were able to recreate Nolen's solution in JS without too much crazyness. So what's the big deal after all? I think it is this: Nolen's solution uses no callbacks and I think that's really his main point. In this toy example it may not seem like a big deal, but for those who've dealt with callback hell, it probably will be a big deal. Callback hell is essentailly a way of describing the following problem - Callbacks are not a good way of representing processes and flows throguh a program. This is because if you want to impose any kind of ordering, you quickly start nesting callbacks and lead to code that can be hard to understand. On the other hand, the ideas used by core async do a great job of explaining processes. In Nolen's code, it's clear that the following happen in order:

1. An event is pulled of the channel
2. That event is added to the vector of existing events to create a new vector
3. Peek and Render are called on the new vector

Why is this clear? Because his code is able to describe this process in a very nice, imperative way:

(-> (conj q (<! c))
    (peekn 10))
