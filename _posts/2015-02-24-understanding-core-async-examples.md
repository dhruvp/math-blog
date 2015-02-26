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

Now let's focus on the main concept. We now need to create three processes that fire off events at different rates and somehow collect them all. I'm going to start by recreating the three independent processes that fire at different rates and place their events onto some sort of list. This is easy enough:

{% highlight js %}
subscribeToProcess1 = function (arr) {
  window.setTimeout(function () {
    arr.push(1);
  }, 250);
};
{% endhighlight %}


And likewise for the other processes.

{% highlight js %}
subscribeToProcess2 = function (arr) {
  window.setTimeout(function () {
    arr.push(2);
  }, 1000);
};

subscribeToProcess3 = function (arr) {
  window.setTimeout(function () {
    arr.push(3);
  }, 1500);
};
{% endhighlight %}

Ok now that I have these processes set up, let me call them. I'm going to create an array to collect all the events.

{% highlight js %}
var collector = [];

subscribeToProcess1(collector);
subscribeToProcess2(collector);
subscribeToProcess3(collector);
{% endhighlight %}

## And this is where it all breaks down. ##

If I'm to proceed. I need to do something like what Nolen does here:

{% highlight clojure %}
(go (loop [q []]
      (set-html! out (render q))
      (recur (-> (conj q (<! c)) (peekn 10)))))
{% endhighlight %}

To break down what's happening above, Nolen is basically saying listen to the channel c (<! c), and whenever a new element arrives, place it onto a new array that's basically my old list of processes (q) with the new event at the end (conj q (<! c)). What's amazing here is that this code is not blocking! Because it's within a go loop, the code just causes the current goroutine (a light weight thread) to park and give execution back to the main thread until we get an element off the channel c.

Can I replicate this functionality? I could pass in a callback function to the individual processes and ask them to call something whenever they add something to the collector. That would kind of be like an ES7 Object.Observe() on my push array. Let's see what happens.

{% highlight js %}
subscribeToProcess1 = function (callback) {
  window.setTimeout(function () {
    callback(1);
  }, 250);
};

collector = [];
callback = fn (event) {
  render(peek(collector.concat([event]), 10));
  collector.push(event);
};
subscribeToProcess1(collector, callback);
subscribeToProcess1(collector, callback);
subscribeToProcess1(collector, callback);
{% endhighlight %}

This does indeed works like Nolen's example. Whenever one of my processes fires an event, it will add the event to the collector, and then render and peek will be called on the collector to display the values. And indeed, the array passed in to peek and render will not be mutated. So then what's the big deal?


What's the big deal?
======================================

One of the main differences between Nolen's solution and our JS solution is that Nolen separated the idea of communication between processes, and the collection of events into two distinct data structures - a channel, and his vector q. The channel is very much like our array collector. It is a shared mutable entity that collects all the events.
<!--
If I just make the collector array the same as the array that renders my final output, I should be able to pull of what Nolen achieves. Let's see what I mean:

{% highlight js %}
var collector = [];

subscribeToProcess1(collector);
subscribeToProcess2(collector);
subscribeToProcess3(collector);

render(collector);
{% endhighlight %}

There are some more changes I need to do to make this work though. I need to have my processes place the right type of elements (strings) onto my collector array. I don't have the luxury of calling a separate render function on the array whenever I find out it updates

BOOM. I'm done. Note that we essentially pass the array around and allow the processes to push directly to it. If you see this closely, we are basically treating our array exactly like the channel in Nolen's blog post! But such a design has a weak separation of concerns between the producer of the events (the independent processes that fire events) and the receiver (our array). However, if we use channels, they can be independent so long as they share a channel. In David Nolen's example, the processes don't care who or what is consuming their output.

Now the question to me is this - how important is it to you that you shouldn't mutate state? Because, as we saw, it's pretty easy to do what Nolen did with mutable state. I personally haven't fully answered this question for myself. Perhaps you might have and realized immutability is the way to go. If you have, hopefully this blog post has shown you why Core.Async should be invaluable! -->
