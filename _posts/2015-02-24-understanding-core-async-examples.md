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

Ok the rest should be just as easy right :)? We now need to create three processes that fire off events at different rates and somehow collect them all. Traditionally in javascript, we use events and callbacks to communicate between separate async processes. Promises aren't quite applicable as they are meant for one off events - not like the processes we have here that fire again and again. Let's see if we can pull off a callback approach here. I can attach a callback to each of the processes and trigger the callbacks when the processes finish. So I'm going to just create a function that takes in a callback and an array, and calls the callback on the array when the event finishes. I'm using this array to collect the events.

{% highlight js %}
subscribeToProcess1 = function (callback, arr) {
  window.setTimeout(function () {
    callback(1, arr);
  }, 250);
};
{% endhighlight %}


And likewise for the other processes.

{% highlight js %}
subscribeToProcess2 = function (callback, arr) {
  window.setTimeout(function () {
    callback(2, arr);
  }, 1000);
};

subscribeToProcess3 = function (callback, arr) {
  window.setTimeout(function () {
    callback(3, arr);
  }, 1500);
};
{% endhighlight %}

Ok now that I have these processes set up, let me call them. I'm going to create an array to store all the events.

{% highlight js %}
var processes = [];
{% endhighlight %}
Now for the callback. I'm going to try and make my callback function non mutating. How about something like this?

{% highlight js %}
callback = function (event, arr) {
  return arr.concat([event]);
};

subscribeToProcess1(callback, processes);
subscribeToProcess2(callback, processes);
subscribeToProcess3(callback, processes);
{% endhighlight %}

## And this is where it all breaks down. ##

Why? Our callback is not going to do anything!!! It just returns a new array somewhere but no one is using it!

See the problem is that callbacks are kind of by definition Side Effecting. Since the process creating a callback can't use what it returns, we HAVE to have our callback mutate some state somewhere. If I had created a callback that didn't mutate any state, would it have any point? NO! I would be in the exact same place had I not run it!  I would have no way of finding out what happened as a result of calling the callback! THAT is why Nolen's example should knock you off your seat if you're big on JS and eventing. He's able to have different processes communicate without using any mutable state! Awesome.

Now if I use a callback function like the one below, my code is trivial.

callback = function (event, processes) {
  processes.push(event);
}

{% highlight js %}
subscribeToProcess1(callback, processes);
subscribeToProcess2(callback, processes);
subscribeToProcess3(callback, processes);
{% endhighlight %}

BOOM. I'm done. Note that we essentially pass the array around and allow the processes to push directly to it. If you see this closely, we are basically treating our array exactly like the channel in Nolen's blog post! But such a design has a weak separation of concerns between the producer of the events (the independent processes that fire events) and the receiver (our array). However, if we use channels, they can be independent so long as they share a channel. In David Nolen's example, the processes don't care who or what is consuming their output.

Now the question to me is this - how important is it to you that you shouldn't mutate state? Because, as we saw, it's pretty easy to do what Nolen did with mutable state. I personally haven't fully answered this question for myself. Perhaps you might have and realized immutability is the way to go. If you have, hopefully this blog post has shown you why Core.Async should be invaluable!
