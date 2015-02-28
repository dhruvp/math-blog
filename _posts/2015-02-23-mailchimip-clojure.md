---
layout: post
title: Building a login form in Clojurescript and Reagent
comments: true

---

I recently have been reading up on LISP (on LISP) a lot lately and have been quite excited by the ideas and simplicity of the language. So I looked for a nice project to get started on and decided to try building a simple Mailchimp-esque login form in Clojurescript to get my feet wet. You can see the dead simple demo <a href="https://dhruvp.github.io/mailchimp-form-cljs/" target="_blank">here</a>, and the full repo <a href="https://github.com/dhruvp/mailchimp-form-cljs" target="_blank">here</a>. It is inspired by Lukas Ruebbelke's awesome <a href="http://onehungrymind.com/build-mailchimp-signup-form-angularjs/" target="_blank">post</a> on the same idea, but in Angular. Below, I'm going to walk you through the process of how to get from 0 to a working site and all the cool things I learned along the way. Ready? LEGGO!


What is Clojurescript
---------------------

Clojurescript is tightly associated with Clojure, the LISP with all the attention these days that runs on the JVM. The language itself is almost identical to Clojure with the primary difference being that Clojurescript compiles to Javascript and thus can be used for client side code! If you want to learn more about Clojure and Clojurescript, do listen to Rich Hickey's talks on the language and its ideas. They're really well presented and beautifully explained. See the following:

* <a href="https://www.infoq.com/author/Rich-Hickey" target="_blank">A collection of Rich Hickey Talks</a>
* <a href="https://www.braveclojure.com/" target="_blank">An introduction to learning Clojure
* <a href="https://github.com/magomimmo/modern-cljs">A series of tutorials on Clojurescript</a>


What are we going to do?
------------------------

1. Setup a development process for Clojurescript
2. Walk through building a simple form for login with the following:
  * Validate the form as it's being typed
  * Hide and show labels based on your focus

Alright then! On to step 1.


Setting up your developer workflow
----------------------------------

First, let's get a developer flow going so that the build process gets out of the way and we can focus on coding. Do the following:

1. Install <a href="https://github.com/technomancy/leiningen" target="_blank">Leiningen</a>
  * Leiningen is a tool for automating Clojure project tasks.
2. Go to the directory you wish to create your project in and type the following:
  * {% highlight bash %}
    lein new reagent myproject
    {% endhighlight %}

3. cd into your new project and execute the following:
  * {% highlight bash %}
    lein ring server
    {% endhighlight %}
    * You should see Leiningen try and download a whole host of dependencies. Not to worry!
    * At the end, you should see a server running on localhost:3000

4. Open a new terminal and execute the following from the base of your project:
  * {% highlight bash %}
    lein figwheel
    {% endhighlight %}

## What was all that? ##

Here's what each of those pieces were:

### <a href="https://github.com/technomancy/leiningen" target="_blank">Leiningen</a> ###
This is an absolute necessity for clojure development. It helps automate tasks and even comes with a repl!

### <a href="https://github.com/weavejester/lein-ring" target="_blank">Ring</a> ###
Ring is a simple abstraction for HTTP in Clojure. It allows you to create a webserver, define middleware etc.


### <a href="https://github.com/bhauman/lein-figwheel" target="_blank">Figwheel</a> ###
Figwheel autoreloads and compiles your clojurescript code so that you can live code and see your changes update in the browser. It also comes with a repl for your clojurescript so you can evaluate your code there. This will come in handy.

### <a href="https://github.com/reagent-project/reagent" target="_blank">Reagent</a> ###
Reagent wraps the React.js library and provides a neat Clojurescript interface to it. This is my first time using it and it's been very simple to pick up and use.


## Understanding the basic setup ##

Let's get started then. We're going to first look at some of the scaffolding code and understand at a high level what's going on. The code is in this <a href="https://github.com/dhruvp/mailchimp-form-cljs" target="_blank">repo</a> for following along.

Open up the core.cljs file in ```src/cljs/<your-project>/core.cljs``` in emacs or your favorite editor.

You should see a few function definitions under the heading "Views". This is the first thing we're going to edit. Each of these functions return separate DOM elements. If you check out the code under the Routes heading, you should see the following:
{% highlight clojure  %}
(secretary/defroute "/" []
  (session/put! :current-page #'home-page))
{% endhighlight %}

What's happening there is <a href="https://github.com/gf3/secretary" target="_blank">Secretary</a>, another Clojurescript library we are using for routing, is matching the route "/" to the home-page function we defined in the views section. The function is simply setting a session variable, :current-page, to be home-page upon the match.

Then, at the bottom of the page, we see are telling reagent to render what's defined by current-page, and bind it to whatever is at document.getElementById("app"). That's defined here:

{% highlight clojure  %}
;; Initialize app
(defn init! []
  (hook-browser-navigation!)
  (reagent/render-component [current-page] (.getElementById js/document "app")))
{% endhighlight %}

Ok cool. So we are just going to play around with the home page to get what we need. Let's take a closer look at how the home-page view is being defined quickly.

{% highlight clojure  %}
(defn home-page []
  [:div [:h2 "Welcome to my-project"]
   [:div [:a {:href "#/about"} "go to about page"]]])
 {% endhighlight %}

home-page is just a function that returns DOM elements (theme alert - we are going to make many such functions!). The syntax for defining HTML is similar to [hiccup](https://github.com/weavejester/hiccup) in that HTML is represented by clojure vectors. The first element of the vector is the tag of the element (in this case :div as in [:div ...]). We can then place other vectors(that represent elements) inside the original vector to represent element nesting (in the example above, the Welcome to my Project h2 is nested inside the div). So to show an example, I've pasted a vector representation of a DOM and its corresponding HTML element below it.

{% highlight clojure %}
[:div [:h2 "Welcome to my-project"]
 [:div [:a {:href "#/about"} "go to about page"]]]
{% endhighlight %}

And the HTML:

{% highlight html %}
<div>
  <h2>Welcome to my-project</h2>
  <div>
    <a href="#/about" go to about page></a>
  </div>
</div>
{% endhighlight %}

This is cool because we can now pass along representations of DOM elements as first class data structures! I can pass them to functions, return them, map over them, compose them ... Basically the possibilities are endless.


## Starting to build the form ##


Ok now let's remove the gunk and focus just on the home page. We don't really need the about page. Edit the home-page code to be

{% highlight clojure  %}
(defn home-page []
  [:div {:class "signup-wrapper"}
    [:h2 "Welcome to TestChimp"]
    [:form]])
 {% endhighlight %}


We now have an empty form! Look at that.

Let's now create a function for rendering an email-input component. We define a simple email-input function that for now will return an empty-div. We'll fix it shortly.

{% highlight clojure  %}
(defn email-input
  []
  [:div])
{% endhighlight %}


## Data Binding ##

Ok back to the form. We're going to need a variable to track the state of the email-address field and auto updates as users type in their email address. In Angular and similar frameworks, we would achieve this by using some form of two way data binding. In reagent, we do something very similar using an Atom. Atoms are one of the few mutable data structure in Clojure. Reagent extends a Clojure Atom by ensuring that whenever an Atom is mutated, any component that uses it is rerendered (so we don't have to worry about updating our views). So let's use that!


Let's just create a new atom for email-address to start.

{% highlight clojure  %}
(defn home-page []
  ;; We define the email-address as an atom right here
  (let [email-address (atom nil)]
    (fn []
      [:div {:class "signup-wrapper"}
       [:h2 "Welcome to TestChimp"]
       [:form]])))
{% endhighlight %}

Notice how we changed home-page now to return a function. Reagent requires that if we do any setup via lets etc., we return a function that in turn returns the elements we want. This just sets up the lexical scoping up front.

## The Building Blocks of our UI - Functions ##

Let's now create the HTML for our actual email input form. We're going to do this by creating a function that is just responsible for the UI of the email input. What's awesome about this is that functions are now the building blocks of our UI. That's exactly how LISP was intended to be used!

Let's develop a generic function for input-elements, and have the email-input just be a specific application of that function.

{% highlight clojure  %}
(defn input-element
  "An input element which updates its value on change"
  [id name type value]
  [:input {:id id
           :name name
           :class "form-control"
           :type type
           :required ""
           :value @value
           :on-change #(reset! value (-> % .-target .-value))}])

(defn email-input
  [email-address-atom]
  (input-element "email" "email" "email" email-address-atom))
{% endhighlight %}

Let's now use this UI component and put it into our original form.


{% highlight clojure  %}
(defn home-page []
  ;; We define the email-address as an atom right here
  (let [email-address (atom nil)]
    (fn []
      [:div {:class "signup-wrapper"}
       [:h2 "Welcome to TestChimp"]
       [:form
       ;; We use the email-input component here
        [email-input email-address]]])))
{% endhighlight %}


Notice how we compose the email-input component into a form div by just placing a vector [email-input email-address] inside the vector describing the form. Super simple! The first element of the vector is just the name of the function defining the component and the next elements are the arguments to that function. You can see how easy it is to build and compose components to make simple, modular ui elements.


## Implementing Two Way Data Binding ##

Now, we need to implement a basic form of two way data binding so that when the user types something in we are able to track it. We can implement this with an :on-change attribute on our element. We pass the following function into :on-change attribute of the input element.

{% highlight clojure %}
#(reset! value (-> % .-target .-value))
{% endhighlight %}

Here, we are resetting the value of atom to be the output of (-> % .-target .-value). The hell is that? That is a [macro](http://clojuredocs.org/clojure.core/-%3E) that expands to (.-value (.-target %)) or just event.target.value in JavaScript. Note that .-value and .-target are how we call JavaScript properties in Clojurescript (yes! Clojurescript let's you talk to JavaScript objects!). The cool thing here is we just have to change the atom here and ANY other component that uses this atom rerenders automatically! This is some sweet stuff already.

And what's with the "@value" we passed to the value field of input? Well the @ is just telling the function to apply the value of the atom (So that we don't pass in an atom which HTML has no idea how to display!).

So now if you check out localhost:3000, you should see a simple page with an input for your email-address! Add in the following to display the email address.

{% highlight clojure  %}
(defn home-page []
  (let [email-address (atom nil)]
    (fn []
      [:div {:class "signup-wrapper"}
       [:h2 "Welcome to TestChimp"]
       [:form
        [email-input email-address]]
       [:div "EMAIL ADDRESS IS " @email-address]])))
{% endhighlight %}


## Sharing state between components ##

Ok, now I want to display a little message that says "What is your email address?" when you click on the email box. Let's create a component for that.

{% highlight clojure  %}
;;generic function
(defn prompt-message
  "A prompt that will animate to help the user with a given input"
  [message]
  [:div {:class "my-messages"}
   [:div {:class "prompt message-animation"} [:p message]]])

;;specific function
(defn email-prompt
  []
  (prompt-message "What's your email address?"))
{% endhighlight %}

Depending on when that input is in focus, we need to hide or show the component we defined above. The below function is going to do just that. It will take in information about the input, and a prompt element, and return a representation of a DOM element that has an input field, and a prompt field that appears above it if the input is in focus.

{% highlight clojure  %}
(defn input-and-prompt
  "Creates an input box and a prompt box that appears above the input when the input comes into focus."
  [label-value input-name input-type input-element-arg prompt-element]
  (let [input-focus (atom false)]
    (fn []
      [:div
       [:label label-value]
       (if @input-focus prompt-element [:div])
       [input-element input-name input-name input-type input-element-arg input-focus]])))

{% endhighlight %}


Let's dive in a little deeper. The below snippet is what hides and shows the prompt element:

{% highlight clojure  %}
(if @input-focus prompt-element [:div])
{% endhighlight %}

If the input-focus atom is set to true, we return the prompt-element, otherwise, we return an empty div. COOL! We need to pass this input-focus atom to our input-element and have it update this atom on focus or blur. Let's share this state variable by making input-element use it.

{% highlight clojure  %}
(defn input-element
  "An input element which updates its value and on focus parameters on change, blur, and focus"
  [id name type value in-focus]
  [:input {:id id
           :name name
           :class "form-control"
           :type type
           :required ""
           :value @value
           :on-change #(reset! value (-> % .-target .-value))
           ;; Below we change the state of in-focus
           :on-focus #(swap! in-focus not)
           :on-blur #(swap! in-focus not)}])
{% endhighlight %}

So now we have our input element swap the in-focus atom to be its converse when an on-focus or on-blur event happens. Dope.

## Putting it all together ##

Let's now use all these functions we've built.

Rename the email-input method to be email-form, and change it to be what you see below so that it uses input-and-prompt.

{% highlight clojure  %}
(defn email-form
  [email-address-atom]
  (input-and-prompt "email"
                    "email"
                    "email"
                    email-address-atom
                    [prompt-message "What's your email?"]))
{% endhighlight %}

Right now, your home-page function should be:

{% highlight clojure  %}
(defn home-page []
  (let [email-address (atom nil)]
    (fn []
      [:div {:class "signup-wrapper"}
       [:h2 "Welcome to TestChimp"]
       [:form
        [email-form email-address]]])))
{% endhighlight %}


Try it out! As you click in and click out, you should see the prompt message appear and disappear.
Finally, we want a little validation. If the field is required, we want our form to throw out a little message if it's not filled in. This is a simple addition. Let's change our input-and-prompt method to take in a required? attribute and display a message saying "Field is required!" when the field is empty.

{% highlight clojure  %}
(defn input-and-prompt
  "Creates an input box and a prompt box that appears above the input when the input comes into focus. Also throws in a little required message"
  [label-value input-name input-type input-element-arg prompt-element required?]
  (let [input-focus (atom false)]
    (fn []
      [:div
       [:label label-value]
       (if @input-focus prompt-element [:div])
       [input-element input-name input-name input-type input-element-arg input-focus]
       (if (and required? (= "" @input-element-arg))
         [:div "Field is required!"]
         [:div])])))

(defn email-form
 [email-address-atom]
 (input-and-prompt "email"
                   "email"
                   "email"
                   email-address-atom
                   [prompt-message "What's your email?"]
                   true))
{% endhighlight %}


## The power of generics - create a name form and a password form ##

Hopefully this works as expected. Now you must be thinking, why did we define so many generic components instead of directly creating the components themselves? Couldn't we have tailored input-and-prompt to just worry about email addresses? Well we could have. But because we made it generic, we now a password, and name form for free! Just add in the following:

{% highlight clojure  %}
(defn name-form [name-atom]
  (input-and-prompt "name"
                    "name"
                    "text"
                    name-atom
                    (prompt-message "What's your name?")
                    true))
(defn password-form [password-atom]
  (input-and-prompt "password"
                    "password"
                    "password"
                    password-atom
                    (prompt-message "What's your password?")
                    true))
{% endhighlight %}

This to me is a big deal. We can now create UI elements using reusable, testable, utility functions. I don't think that's particularly easy in most setups. Let's add in these additional forms by changing the home-page method to be the following:

{% highlight clojure %}
(defn home-page []
 (let [email-address (atom nil)
       name (atom nil)
       password (atom nil)]
   (fn []
     [:div {:class "signup-wrapper"}
      [:h2 "Welcome to TestChimp"]
      [:form
       [email-form email-address]
       [name-form name]
       [password-form password]]])))
{% endhighlight %}

## Bonus - Applying Additional validation on the password ##

Ok! Onto the last challenge. We are going to validate the password field a little more heavily. We want the password to be at least 8 characters long, have at least 1 special character, and have at least one digit. Let's start by defining some regexps to check for this.

{% highlight clojure  %}

(defn check-nil-then-predicate
  "Check if the value is nil, then apply the predicate"
  [value predicate]
  (if (nil? value)
    false
    (predicate value)))


(defn eight-or-more-characters?
  [word]
  (check-nil-then-predicate word (fn [arg] (> (count arg) 7))))


(defn has-special-character?
  [word]
  (check-nil-then-predicate word (fn [arg] (boolean (first (re-seq #"\W+" arg))))))


(defn has-number?
  [word]
  (check-nil-then-predicate word (fn [arg] (boolean (re-seq #"\d+" arg)))))

{% endhighlight %}

Ok great. We now move on to defining the component that will show what requirements we haven't satisfied yet in our password. It's going to be a list where requirements disappear as we meet them. The function will take in a data structure like the one pasted below it.

{% highlight clojure  %}

(defn password-requirements
  "A list to describe which password requirements have been met so far"
  [password requirements]
  [:div
   [:ul (->> requirements
             (filter (fn [req] (not ((:check-fn req) @password))))
             (doall)
             (map (fn [req] ^{:key req} [:li (:message req)])))]])
{% endhighlight %}

Let's break down the function above. It's taking in a password (atom) and a set of requirements. You can see what the requirements data structure looks like below.

{% highlight clojure  %}
[{:message "8 or more characters" :check-fn eight-or-more-characters?}
 {:message "At least one special character" :check-fn has-special-character?}
 {:message "At least one number" :check-fn has-number?}]

{% endhighlight %}

password-requirements then returns a div with a ul list inside it.

For each requirement, we filter out the requirements that aren't passed, and then map those requirements to create :li elements whose contents are just the messages of the requirements. This is cool. Again, this shows how we are doing things most templating languages can't really do.

Let's now change our password-form to use these requirements.

{% highlight clojure  %}
(defn password-form
  [password]
  (let [password-type-atom (atom "password")]
    (fn []
      [:div
       [(input-and-prompt "password"
                          "password"
                          @password-type-atom
                          password
                          (prompt-message "What's your password")
                          true)]
       [password-requirements password [{:message "8 or more characters" :check-fn eight-or-more-characters?}
                                        {:message "At least one special character" :check-fn has-special-character?}
                                        {:message "At least one number" :check-fn has-number?}]]])))
{% endhighlight %}


Finally, notice that password-form, input-form etc. aren't in a form-group class. Let's fix that. We create the following function:

{% highlight clojure  %}
(defn wrap-as-element-in-form
  [element]
  [:div {:class="row form-group"}
   element])
{% endhighlight %}

And then use it to wrap all our forms in form-group elements.

{% highlight clojure  %}
(defn home-page []
  (let [email-address (atom nil)
        name (atom nil)
        password (atom nil)]
    (fn []
      [:div {:class "signup-wrapper"}
       [:h2 "Welcome to TestChimp"]
       [:form
        (wrap-as-element-in-form [email-form email-address])
        (wrap-as-element-in-form [name-form name])
        (wrap-as-element-in-form [password-form password])]])))
{% endhighlight %}


That's it for now! Your final code should match the file [here](https://github.com/dhruvp/mailchimp-form-cljs/blob/master/src/cljs/mailchimp_form/core.cljs).


## So what have we learned? ##

We went through something really cool in this post (I think at least!). We applied the Clojure principle of using simple, composable functions as a way of building UIs! And why should we not? Can't frontend software development also use the same principles of modularity, simplicity, and composition? Indeed, I think with Clojurescript and Reagent, it can.

More specifically, here are my main takeaways:

1. It's really nice to be able to treat UI elements as first class data structures that you can compose and apply logic on. I think it does lead to more modular pieces.

2. It's also very nice that you can use clojure as your templating language! No need for feeling hamstrung by a lack of functionality there and we don't have to learn any new languages.

3. Reagent is also just a really simple to use library. Atoms abstract away any worrying about rerendering elements and the syntax of using reagent is dead simple.

4. It is hard for me to debug clojurescript code. I still don't know how to do this efficiently. Many times I would see errors and have no idea why they were ocurring. In JavaScript, I would just breakpoint my code to catch the error. Here I couldn't do that. Also, at times I would have to run lein clean and then rerun a cljscript autobuild and this took like 30 seconds each time. You can imagine that this is not fun.
