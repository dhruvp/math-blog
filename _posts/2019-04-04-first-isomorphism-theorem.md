---
layout: post
title: Kernels
comments: false

---

{% katexmm %}

In the last few posts we've focused heavily on [matrices](% post_url 2018-12-31-matrices %}) and their [applications](% post_url 2019-03-20-pagerank %}). In this post we're going to use matrices to learn about some really pretty results in abstract algebra. More specifically, we'll explore the concept of Kernels (Nullspace) and see how they help us succinctly define what a matrix does to its inputs.

I hope that by the end of this post you will:

1. Understand what a Kernel is and see why it's so useful.
2. Realize that all pre-images of points are some translation of the Kernel.
3. Realize that abstract algebra is accessible and really pretty!

### Squashing Spaces

In previous posts, we noticed how matrices are just linear functions. We found that the matrices we studied just rotate or stretch a vector in some way.

<div class='image-block'>
    <img src='https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Art/scaling_2x.png'>
    An example of a function that stretches its input. Source: http://developer.apple.com.
</div>

But we only studied square matrices. What happens when our matrices aren’t square?

Let’s start with a 2x3 matrix that represents a linear function $f$. Maybe something like:

$$ F = \begin{bmatrix} 2 & 1 & 0 \\ 0 & 1 & 3 \end{bmatrix} $$

What happens if I apply this matrix on a vector $v = \begin{bmatrix} 3 \\ 2 \\ 1 \end{bmatrix}$?

$$ F v = \begin{bmatrix} 2 & 1 & 0 \\ 0 & 1 & 3 \end{bmatrix} \begin{bmatrix} 3 \\ 2 \\ 1 \end{bmatrix} $$
$$ F v = \begin{bmatrix} 8 \\ 5 \end{bmatrix} $$

<div class='image-block'>
    <img src='/public/images/kernels/r_3_to_r_2.jpeg'/>
    $f$ maps points from $R^3$ to $R^2$.
</div>

<br />

So $F$ effectively takes vectors in a 3D space and squashes them onto a 2D space! You can think of it something like a what happens when you take a picture on your phone - you are taking a 3D space (the world you see), and collapsing it onto a 2D space (the camera sensor).

<div class='image-block'>
    <img src='https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Pinhole-camera.svg/1200px-Pinhole-camera.svg.png'>
    A camera converts a 3D object (the tree) into a 2d representation (image). Source: Wikipedia.
</div>

The input space for $f$ is $R^3$ and the output space is $R^2$. More formally, we write this as:

$$f: R^3 \rightarrow R^2$$

<h3>Collapsing Points</h3>

When you take a picture and squash a 3D world onto a 2D sensor, you are losing some amount of information. Usually, what happens is points that are far away appear close to each other even though they may be far apart.

We refer to this as a perspective effect but you can also think about it as a loss of depth information when converting from 3D to 2D.

<div class='image-block'>
    <img src='https://images.unsplash.com/photo-1554976757-606d486f5d92?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2204&q=80' />
    Notice how the pillars start seeming closer and closer to eachother even though they are staying the same distance apart. We have lost information about the distance between this pillars when converting to 2D. Our eyes do the same thing as they also convert the 3D world to a 2D representation! Image source: Unsplash.
</div>

Similarly, will our function also "lose" some information and collapse multiple points from the input to the same point in the output?

### The Kernel

Let's start by seeing what points $v = \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix}$ collide onto the origin of the output space - $\begin{bmatrix} 0 \\ 0 \end{bmatrix}$.

<div class='image-block'>
    <img src='/public/images/kernels/map_to_0.jpeg'/>
    Which points map to $\begin{bmatrix}0 \\ 0\end{bmatrix}$?
</div>

We want to solve:

$$Fv = \begin{bmatrix} 0 \\ 0 \end{bmatrix}$$
$$\begin{bmatrix} 2 & 1 & 0 \\ 0 & 1 & 3 \end{bmatrix} \begin{bmatrix} x \\ y \\ z \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \end{bmatrix}$$

Carrying out this multiplication, we see this is satisfied when:

$$2x + y = 0$$
$$y + 3z = 0$$

<div class='highlight-block'>

Solving this for each variable in terms of $y$, we find:

$$\begin{aligned}
x &= -\frac{y}{2} \\
z &= \frac{y}{3}
\end{aligned}$$

So, $f^{-1}(0)$ is a line parameterized by:

$$\begin{aligned}
x &= -\frac{t}{2} \\
y &= t \\
z &= \frac{-t}{3} \\
\end{aligned}$$

for some $t \in R$.

</div>

Some points on this line are:

$v_1 = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}$, 
$v_2 = \begin{bmatrix} -3 \\ 6 \\ -2 \end{bmatrix}$, $v_3 = \begin{bmatrix} -4.5 \\ 9 \\ -3 \end{bmatrix}$


<div class='highlight-block'>
There’s a term for this set - <strong>the Kernel</strong>. We call it the Kernel because this set of vectors maps to the origin, or the core, of the output space.
</div>


<div class='image-block'>
    <img src='/public/images/kernels/kernel_line.png' />
    The Kernel of $f$ is the set of points that $f$ maps to $0$. In this case, it forms a line.
</div>

#### Terminology Aside

Let's get some more quick terminology out of the way before proceeding. We're going to use the following terms:

1. **Image** - the set of outputs of the function (i.e. everything in $f(x)$). The image of a point $x$ is just $f(x)$.

2. **Pre-Image** - the set of inputs for the function (i.e. the $x$ in $f(x)$). The pre-image of a point $y$ is just $f^{-1}(y)$.

### Translations of the Kernel - Mapping to $\begin{bmatrix} 1 \\ 1 \end{bmatrix}$

We found the set of points that map to $\begin{bmatrix} 0 \\ 0 \end{bmatrix}$ (i.e. the pre-image of the origin). We call this set the Kernel or $K$ for short.

Can we now similarly find the set of points that map to $\begin{bmatrix} 1 \\ 1 \end{bmatrix}$?

<div class='highlight-block'>
We're going to do this to show something really cool:
<ul>
<li>
The pre-image of $\begin{bmatrix} 0 \\ 0 \end{bmatrix}$ and $\begin{bmatrix} 1 \\ 1 \end{bmatrix}$ are way more related than you may expect.
</li>
</ul>
</div>

#### Finding the pre-image

Let's start by finding the points that maps to $\begin{bmatrix} 1 \\ 1 \end{bmatrix}$ as before.

$$F v = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$
$$\begin{bmatrix} 2 & 1 & 0 \\ 0 & 1 & 3 \end{bmatrix} \begin{bmatrix} x \\ y \\ z \end{bmatrix} = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$

Solving for each variable, we find that this is just the line defined by:

$$\begin{aligned}
x &= \frac{1-t}{2} \\
y &= t \\
z &= \frac{1-t}{3}
\end{aligned}$$

for some $t \in R$.


<div class='image-block'>
    <img src='/public/images/kernels/inverse_of_1.png' />
    $f^{-1}(0)$ is the set of points that $f$ maps to $\begin{bmatrix} 1 \\ 1 \end{bmatrix}$. This is also a line.
</div>
Some valid point are:

$v = \begin{bmatrix} 0 \\ 1 \\ 0 \end{bmatrix}$, $v = \begin{bmatrix} -3 \\ 7 \\ -2 \end{bmatrix}$


**This line looks awfully similar to the line for $K$ doesn't it?**

Let's see them both on the same graph:

<div class='image-block'>
    <img src='/public/images/kernels/K_and_f_inverse_1.png' />
    Notice that $f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix})$ is parallel to $K$. In other words, $f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix})$ is just $K$ shifted over.
</div>

#### Translating the Kernel

So what's the relation between $f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix})$ and $K = f^{-1}(\begin{bmatrix} 0 \\ 0 \end{bmatrix})$?

<div class='highlight-block'>
$f^{-1}(1)$ is just a simple translation of $K$.

<br />
It is a translation by any vector $v \in f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix})$.
<br />

Or said another way,

$$\begin{aligned}
f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix}) = v + K & \text{, for any $v \in f^{-1}(\begin{bmatrix}1 \\ 1\end{bmatrix})$} \\
\end{aligned}$$

</div>

This seems kind of too good to be true. Is it? Let's test it out!

1. Let's take a point $k \in K$. For instance, $k = \begin{bmatrix} -3 \\ 6 \\ 2 \end{bmatrix}$.

2. Let's take a $v \in f^{-1}(\begin{bmatrix} 1 \\ 1 \end{bmatrix})$ like $v = \begin{bmatrix} 0 \\ 1 \\ 0 \end{bmatrix}$.

What's $f(k + v)$?

$$\begin{aligned}
f(k + v) &= f(\begin{bmatrix} -3 \\ 6 \\ 2 \end{bmatrix} + \begin{bmatrix} 0 \\ 1 \\ 0 \end{bmatrix}) \\
&= f(\begin{bmatrix} -3 \\ 7 \\ 2 \end{bmatrix}) \\
&= F \begin{bmatrix} -3 \\ 7 \\ 2 \end{bmatrix} \\
&= \begin{bmatrix} 2 & 1 & 0 \\ 0 & 1 & 3 \end{bmatrix} \begin{bmatrix} -3 \\ 7 \\ 2 \end{bmatrix} \\
&= \begin{bmatrix} 1 \\ 1 \end{bmatrix}
\end{aligned}$$
### All Pre-Images are Translations of the Kernel

Ok there's something kind of mind blowing going on here:

* We took one point in $f^{-1}(\begin{bmatrix} 1 \\ 1 \end{bmatrix})$, added it to $K$, and suddenly we got **ALL** of $f^{-1}(\begin{bmatrix} 1 \\ 1 \end{bmatrix})$.

<div class='image-block'>
    <img src='/public/images/kernels/kernel_translation.gif'/>
    Adding $K$ to $v$ gives us the full pre-image, $f^{-1}(\begin{bmatrix} 1 \\ 1 \end{bmatrix})$. 
</div>

In fact this is true more generally!

<div class='highlight-block'>
If you give me <strong>ANY</strong> point that maps to some point $f(v)$, say $v$, then I can find <strong>ALL</strong> the points that map to $f(v)$ by just adding $v+K$.
</div>

### Breaking Down Why

Another way of saying the above is:

$$f(v+K) = f(v) \text{, for any } v \in R^3 $$

Let's break down why this is true. Take any $k \in K$ (in the kernel). Then,

$$\begin{aligned}
f(v+k) &= f(v) + f(k) & \text{Since $f$ is a linear function} \\
f(v+k) &= f(v) + 0 & \text{Since } k \in K\\
f(v+k) &= f(v)
\end{aligned}$$

<div class='image-block'>
    <iframe src="https://player.vimeo.com/video/330255721" width="640" height="564" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
    By decomposing $v+k$ into $v$, and $k$, we see that $f(v+k) = f(v)$.
</div>

Additionally, given this is true for some $v+k$, this is true for all points on the line $v+K$. The reason is that the different amounts of $K$ all contribute nothing different and it's only the value of $v$ that matters to $f$. This is shown below:

<div class='image-block'>
    <img src='/public/images/kernels/f_v+K=f_v.gif'>
    Any point in $K$, such as $k$, $k'$, and $k''$, does not change the result of $f$. Hence, $f(v+K) = f(v)$.
</div>

Pretty simple!! This is possible because, as you remember from our first blog post on matrices, $f$ is a linear function and linear functions have the property that $f(x+y) = f(x)+f(y)$!

### The Relation Between Translations of $K$ and Points in the Image

We've already seen something really cool - all the pre-images of $f$ are of the form $v+K$ (i.e. just translations of $K$).

Now is there any relation between how far apart two translations of $K$ are (say $v+K$ and $w+K$) and how far apart their images are ($f(v)$, $f(w)$)?

Yes!

<div class='highlight-block'>
If $v+K$ and $w+K$ are $v'$ apart, their images will be $f(v')$ apart!
</div>

<div class='image-block'>
    <img src='/public/images/kernels/distances.jpeg'/>
    If $v+K$ and $w+K$ are $v'$ apart, their images will be $f(v')$ apart.
</div>

Why is this the case? It again follows pretty simply:

$$
\begin{aligned}
w+K &= v+K + v'+K \\
w+K &= v+v' + K \\
f(w+K) &= f(v+v'+K) \\
f(w) &= f(v+v') \\
f(w) &= f(v) + f(v)' \\
\end{aligned}
$$

### Overall Space

Let's now take a step back and view what's happening in the overall space.

Every point in the image can be seen as a mapping of some translation of $K$. As we move $K$ around, we get new points in the image!

<div class='image-block'>
    <img src='/public/images/kernels/overall_space.gif'>
</div>

### Conclusion

We've now seen some really cool things that you may not have noticed before:

1. Every matrix is a linear function and that linear function will have some **kernel** $K$ that maps to $0$.
2. All pre-images of output points are just going to be translations of $K$.
3. If $v'$ is the distance between the translations of $K$, $f(v')$ is the distance between their images.

The last point actually leads us to the first isomorphism theorem of group theory. This broadly states that the relation between the sets of pre-images of a special type of function known as a homomorphism (in our case $f$) is the exact same as the relation between the set of output points.

There are many practical uses of this knowledge but I wanted to share it for simpler reasons.  Sometimes math is just pretty - it has all these cool coincidences that fit together so nicely that you can't help but enjoy seeing them.

For example:

1. Who would have thought that all the pre-image sets are just translations of eachother?

2. Or that the relation between these pre-image sets mirrors the relation between the points in the image?

I hope you enjoyed getting a taste of some abstract algebra and I'll see you in the next post!

{% endkatexmm %}
