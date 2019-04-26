---
layout: post
title: You Could Have Come Up With Eigenvectors - Here's How
comments: false

---

{% katexmm %}

In the [last post]({% post_url 2018-12-31-matrices %}), we developed an intuition for matrices. We found that they are just compact representations of linear maps and that adding and multiplying matrices are just ways of combining the underlying linear maps.

In this post, we're going to dive deeper into the world of linear algebra and cover eigenvectors. Eigenvectors are central to Linear Algebra and help us understand many interesting properties of linear maps including:
1. The effect of applying the linear map repeatedly on an input.
2. How the linear map rotates the space. In fact eigenvectors were first derived to study the axis of rotation of planets!

<p class='image-block'>
    <img src='https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Saturn_during_Equinox.jpg/2560px-Saturn_during_Equinox.jpg' />
    Eigenvectors helped early mathematicians study how the planets rotate. Image Source: Wikipedia.
</p>


 For a more modern example, eigenvectors are at the heart of one of the most important algorithms of all time - the original Page Rank algorithm that powers Google Search.

#### Our Goals

In this post we're going to try and derive eigenvectors ourselves. To really create a strong motivation, we're going to explore basis vectors, matrices in different bases, and matrix diagonalization. So hang in there and wait for the big reveal - I promise it will be really exciting when it all comes together!

Everything we'll be doing is going to be in the 2D space $R^2$ - the standard coordinate plane over real numbers you're probably already used to.

### Basis Vectors

We saw in the last post how we can derive the matrix for a given linear map $f$:

>$f(x)$ (as we defined it in the previous section) can be represented by the notation
$$\begin{bmatrix} f(\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}) & f(\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}) \end{bmatrix}$$
$$ = \begin{bmatrix} \textcolor{blue}{3} & \textcolor{#228B22}{0} \\ \textcolor{blue}{0} & \textcolor{#228B22}{5} \end{bmatrix} $$
>This is extremely cool - we can describe the entire function and how it operates on an infinite number of points by a little 4 value table.


But why did we choose $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ to define the columns of the matrix? Why not some other pair like $\textcolor{blue}{\begin{bmatrix} 3 \\ 3 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 0 \end{bmatrix}}$?

Intuitively, we think of $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ as units that we can use to create other vectors. In fact, we can break down every vector in $R^2$ into some combination of these two vectors.

<p class='image-block'>
    <img src='/public/images/coordinate.png' />
    We can reach any point in the coordinate plan by combining our two vectors.
</p>

More formally, when two vectors are able to combine in different ways to create all other vectors in $R^2$, we say that those vectors $span$ the space. The minimum number of vectors you need to span $R^2$ is 2. So when we have 2 vectors that span $R^2$, we call those vectors a **basis**.

$\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ are **basis vectors for $R^2$**.

You can think of basis vectors as the minimal building blocks for the space. We can combine them in different amounts to reach all vectors we could care about.

<p class='image-block'>
    <img src='https://cdn.instructables.com/FQI/N671/JBMK0PCU/FQIN671JBMK0PCU.LARGE.jpg' />
    We can think of basis vectors as the building blocks of the space - we can combine them to create all possible vectors in the space. Image Source: instructables.com.
</p>
<hr />

### Other Basis Vectors for $R^2$

Now are there other pairs of vectors that also form a basis for $R^2$?

Let's start with an example that definitely won't work.

#### Bad Example
$\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} -1 \\ 0 \end{bmatrix}}$.

Can you combine these vectors to create ${\begin{bmatrix} 2 \\ 3 \end{bmatrix}}$? Clearly you can't - we don't have any way to move in the $y$ direction.

<p class='image-block'>
    <img src='/public/images/bad_basis.png' />
    No combination of these two vectors could possible get us the vector $P$.
</p>

### Good Example
What about $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$?

<p class='image-block'>
    <img src='/public/images/good_basis.png' />
    Our new basis vectors.
</p>


Surprisingly, you can! The below image shows how we can reach our previously unreachable point $P$.

<p class='image-block'>
    <img src='/public/images/reaching_p.png' />
    Note we can can combine $3$ units of ${\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$ and $-1$ units of ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ to get us the vector $P$.
</p>

I'll leave a simple proof of this as an appendix at the end of this post so we can keep moving - but it's not too complicated so if you're up for it, give it a go! The main thing we've learned here is that:

**There are multiple valid bases for $R^2$.**

<hr />

### Bases as New Coordinate Axes

In many ways, choosing a new basis is like choosing a new set of axes for the coordinate plane. When we when we switch our basis to say $B = \{\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}, \textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}\}$, our axes just rotate as shown below:

<div class='image-block'>
    <img src='/public/images/axis_rotation.gif' />
    As our second basis vector changed from $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ to $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$, our y axis rotates to be in line with $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.
</div>

<br />

As a result of this, the same notation for a vector means different things in different bases.

In the original basis, ${\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}}$ meant:

* The vector you get when you compute $\textcolor{blue}{3 \cdot \begin{bmatrix} 1 \\ 0 \end{bmatrix}} + \textcolor{#228B22}{4 \cdot \begin{bmatrix} 0 \\ 1 \end{bmatrix}}$.
* Or just $\textcolor{blue}{3} \cdot$ <strong><span style='color: blue;'>first basis vector</span></strong> plus $\textcolor{#228B22}{4} \cdot$ <strong><span style='color: #228B22;'>second basis vector</span></strong>.

<p class='image-block'>
    <img src='/public/images/canonical_notation.png' />
    In our usual notation, ${\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}}$ means $3$ units of $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $4$ units of $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$
</p>

Now when we use a different basis , the meaning of this notation actually changes.

For the basis is $B = \{\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}, \textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}\}$, the vector $\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}_{B}$ means:

* The vector you get from: $\textcolor{blue}{3 \cdot \begin{bmatrix} 1 \\ 0 \end{bmatrix}} + \textcolor{#228B22}{4 \cdot \begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.

You can see this change below:

<p class='image-block'>
    <img src='/public/images/new_basis_notation.png' />
    In the notation of basis $B$, ${\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}}_{B}$ means $3$ units of $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $4$ units of $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$ giving us point $P_{B}$.
</p>

By changing the underlying axes, we changed the location of $P$ even though it's still called $(3, 4)$. You can see this below:

<p class='image-block'>
    <img src='/public/images/point_movement.gif' />
    The point $P$ also changes position when we change the basis. It is still $3$ parts first basis vector, $4$ parts second basis vector. But since the underlying basis vectors have changed, it also changes.
</p>

<div class='highlight-block'>
    So the vectors ${\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}}$ and ${\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}}_{B}$ refer to different actual vectors based on basis $B$.
</div>

### Matrix Notation Based on Bases

Similarly the same notation also means different things for matrices based on the basis. Earlier, the matrix $F$ for the function $f$ was represented by:

$$F = \begin{bmatrix} f(\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}) & f(\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}) \end{bmatrix}$$

When I use the basis $B = \{\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}, \textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}\}$, the matrix $F_{B}$ in basis $B$ becomes:

$$F_{B} = \begin{bmatrix} f(\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}})_{B} & f(\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}})_{B} \end{bmatrix}$$

More generally, for a basis $B = \{b_1, b_2\}$, the matrix is:

$$F_{B} = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix}$$

<hr />

### The Power of Diagonals

We took this short detour into notation for a very specific reason - rewriting a matrix in a different basis is actually a neat trick that allows us to reconfigure the matrix to make it easier to use. How? Let's find out with a quick example.

Let's say I have a matrix $F$ (representing a linear function) that I need to apply again and again (say 5 times) on a vector $v$.

This would be:

 $F \cdot F \cdot F \cdot F \cdot F \cdot v$.

Usually, calculating this is really cumbersome.

<p class="image-block">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Matrix_multiplication_diagram_2.svg/313px-Matrix_multiplication_diagram_2.svg.png" />
Can you imagine doing this 5 times in a row? Yeesh. Image Source: Wikipedia.
</p>


But let's imagine for a moment that $F$ was a diagonal matrix (i.e. something like $F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $). If this were the case, then this multiplication would be EASY.

Why? Let's see what $F \cdot F$ is:

$$F \cdot F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} \cdot \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $$
$$F \cdot F = \begin{bmatrix} a \cdot a + 0 \cdot 0 & a \cdot 0 + 0 \cdot b  \\ 0 \cdot a + b \cdot 0 & 0 \cdot 0 + b \cdot b \end{bmatrix}$$
$$F \cdot F =  \begin{bmatrix} a^2 & 0 \\ 0 & b^2 \end{bmatrix} $$

<p class='highlight-block'>
More generally,

$$F^{n} = \begin{bmatrix} a^n & 0 \\ 0 & b^n \end{bmatrix}$$

This is way easier to work with!
So how can we get $F$ to be a diagonal matrix?
</p>

<hr />

### Which Basis makes a Matrix Diagonal?

Earlier, we saw that choosing a new basis makes us change how we write down the matrix. So can we find a basis $B = \{b_1, b_2\}$ that converts $F$ into a diagonal matrix?

From earlier, we know that $F_{B}$, the matrix $F$ in the basis $B$, is written as:

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix}$$

For this to be diagonal, we must have:

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix} = {\begin{bmatrix} \lambda_1 & 0 \\ 0 & \lambda_2  \end{bmatrix}}_{B}$$

for some $\lambda_1$ and $\lambda_2$ (i.e. the the top-right and bottom-left elements are $0$).

This implies:

1. $f(\textcolor{blue}{b_1})_{B} =  {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_{B}$.
2. $f(\textcolor{#228B22}{b_2})_{B} = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_{B}$.

Recall our discussion on vector notation in a different basis:

>Say my basis is $B = \{\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}, \textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}\}$.
>Then the vector $\begin{bmatrix} \textcolor{blue}{3} \\ \textcolor{#228B22}{4} \end{bmatrix}_{B}$ means:
> * The vector you get when you compute: $\textcolor{blue}{3 \cdot \begin{bmatrix} 1 \\ 0 \end{bmatrix}} + \textcolor{#228B22}{4 \cdot \begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.


So, we know the following additional information:

$$f(\textcolor{blue}{b_1}) = {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_B = \lambda_1 \cdot \textcolor{blue}{b_1} + 0 \cdot \textcolor{#228B22}{b_2}$$
<div classname='highlight-block'>
    $$ f(\textcolor{blue}{b_1}) = \mathbf{\lambda_1 \cdot \textcolor{blue}{b_1}}$$
</div>

Similarly,

$$f(\textcolor{#228B22}{b_2}) = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_B = 0 \cdot \textcolor{blue}{b_1} + \lambda_2 \cdot \textcolor{#228B22}{b_2}$$
<div classname='highlight-block'>
    $$f(\textcolor{#228B22}{b_2}) = \mathbf{\lambda_2 \cdot \textcolor{#228B22}{b_2}}$$
</div>


#### Seeing this Visually

What do these vectors look like on our coordinate axis?

We saw earlier that choosing a new basis $B = \{b_1, b_2\}$ creates a new coordinate axis for $R^2$ like below:


<div class='image-block'>
    <img src='/public/images/diagonalization/diagonalization.001.jpeg' />
    A new basis $B = \{b_1, b_2\}$ gives us new coordinate axis.
</div>

<br />

Let's plot $f(\textcolor{blue}{b_1})_{B} =  {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_{B}$:

<div class='image-block'>
    <img src='/public/images/diagonalization/diagonalization.002.jpeg' />
</div>

In the graph above, we can see that ${\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_{B} =  \lambda_1 b_1$, so

<div class='highlight-block'>
    $f(\textcolor{blue}{b_1})_{B} = \lambda_1 b_1$
</div>

<br />

Similarly, let's plot $f(\textcolor{#228B22}{b_2})_{B} = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_{B}$:

<div class='image-block'>
    <img src='/public/images/diagonalization/diagonalization.003.jpeg' />
</div>

From the above, we see clearly that ${\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_{B} = \lambda_2 b_2$, so

<div class='highlight-block'>
    $f(\textcolor{blue}{b_2})_{B} = \lambda_2 b_2$
</div>

<br />

#### Rules For Getting a Diagonal

So if we can find a basis $B$ formed by $b_1$ and $b_2$ such that:

<div class='highlight-block'>
    <ol>
        <li>
            $f(\textcolor{blue}{b_1}) = \lambda_1 \textcolor{blue}{b_1}$ and
        </li>
        <li>
            $f(\textcolor{#228B22}{b_2}) = \lambda_2 \textcolor{#228B22}{b_2}$,
        </li>
    </ol>
    then, $F$ can be rewritten as $F_{B}$, where
    $$F_{B} = \begin{bmatrix} \lambda_1 & 0 \\ 0 & \lambda_2  \end{bmatrix}$$
    A nice diagonal matrix!
</div>
<hr />

### Enter Eigenvectors

Is there a special name for the vectors above $b_1$ and $b_2$ that magically let us rewrite a matrix as a diagonal? Yes! These vectors are **the eigenvectors of $f$**. That's right - you derived eigenvectors all by yourself.

<p class='image-block'>
    <img src='https://media.giphy.com/media/d3mlE7uhX8KFgEmY/giphy.gif' />
    You the real MVP.
</p>


<p class='highlight-block'>
More formally, we define an eigenvector of $f$ as any non-zero vector $v$ such that:

$$f(v) = \lambda v $$

or

$$F \cdot v = \lambda v $$
</p>

The basis formed by the eigenvectors is known as the <strong>eigenbasis</strong>. Once we switch to using the eigenbasis, our original problem of finding $f\circ f\circ f \circ f \circ f (v)$ becomes:

$$F_{B} \cdot F_{B} \cdot F_{B} \cdot F_{B} \cdot F_{B} \cdot v_{B}$$
$$ = {\begin{bmatrix} {\lambda_1}^5 & 0 \\ 0 & {\lambda_2}^5 \end{bmatrix}}_{B} $$

<strong>So. Much. Easier.</strong>

<hr />

### An Example

Well this has all been pretty theoretical with abstract vectors like $b$ and $v$ - let's make this concrete with real vectors and matrices to see it in action.

Imagine we had the matrix $F = \begin{bmatrix}2 & 1 \\ 1 & 2 \end{bmatrix}$. Since the goal of this post is not learning how to *find* eigenvectors, I'm just going to give you the eigenvectors for this matrix. They are:

$$b_{1} = \begin{bmatrix} 1 \\ -1 \end{bmatrix}$$
$$b_{2} = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$

The eigenbasis is just $B = \{b_1, b_2\}$.
What is $F_{B}$, the matrix $F$ written in the eigenbasis $B$?

Since $F_B = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix}$, we need to find :
- $f(\textcolor{blue}{b_1})_{B}$ and $f(\textcolor{#228B22}{b_2})_{B}$

We'll break this down by first finding $f(\textcolor{blue}{b_1})$ and $f(\textcolor{#228B22}{b_2})$, and rewrite them in the notation of the eigenbasis $B$ to get $f(\textcolor{blue}{b_1})_{B}$ and $f(\textcolor{#228B22}{b_2})_{B}$.

#### Finding $f(\textcolor{blue}{b_1})$

$f(\textcolor{blue}{b_1})$ is:

$$ f(\textcolor{blue}{b_1}) = F\cdot \textcolor{blue}{b_1} = \begin{bmatrix}2 & 1 \\ 1 & 2\end{bmatrix} \cdot \begin{bmatrix} 1 \\ -1 \end{bmatrix}$$
$$ f(\textcolor{blue}{b_1}) = \begin{bmatrix} 1 \\ -1 \end{bmatrix}$$

#### Finding $f(\textcolor{#228B22}{b_2})$

Similarly,

$$ f(\textcolor{#228B22}{b_2}) = F\cdot \textcolor{#228B22}{b_2} = \begin{bmatrix}2 & 1 \\ 1 & 2\end{bmatrix} \cdot \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$
$$ f(\textcolor{#228B22}{b_2}) = \begin{bmatrix} 3 \\ 3 \end{bmatrix}$$

#### Rewriting the vectors in the basis $B$

We've now found $f(b_1)$ and $f(b_2)$. We need to rewrite these vectors in the notation for our new basis $B$.

What's $f(b_1)_{B}$?

$$f(b_1) = \begin{bmatrix} 1 \\ -1 \end{bmatrix} = \textcolor{blue}{1} \cdot \begin{bmatrix} 1 \\ -1 \end{bmatrix} + \textcolor{#228B22}{0} \cdot \begin{bmatrix} 1 \\ 1 \end{bmatrix} = \textcolor{blue}{1} \cdot b_1 + \textcolor{#228B22}{0} \cdot b_2$$
$$f(b_1)_{B} = \begin{bmatrix} \textcolor{blue}{1} \\ \textcolor{#228B22}{0} \end{bmatrix}$$

Similarly,

$$f(b_2) = \begin{bmatrix} 3 \\ 3 \end{bmatrix} = \textcolor{blue}{0} \cdot \begin{bmatrix} 1 \\ -1 \end{bmatrix} + \textcolor{#228B22}{3} \cdot \begin{bmatrix}1 \\ 1 \end{bmatrix} = \textcolor{blue}{0} \cdot b_1 + \textcolor{#228B22}{3} \cdot b_2$$
$$f(b_2)_{B} = \begin{bmatrix} \textcolor{blue}{0} \\ \textcolor{#228B22}{3} \end{bmatrix}$$

<p class='highlight-block'>
Putting this all together,

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix}$$
$$F_B = \begin{bmatrix} 1 & 0 \\ 0 & 3 \end{bmatrix}$$

So we get the nice diagonal we wanted!
</p>

### Geometric Interpretation of Eigenvectors

Eigenvectors also have extremely interesting geometric properties worth understanding. To see this, let's go back to the definition for an eiegenvector of a linear map $f$ and its matrix $F$.

An eigenvector, is a vector $v$ such that:

$$F \cdot v = \lambda v $$

How are $\lambda v$ and $v$ related? $\lambda v$ is just a scaling of $v$ in the same direction - it can't be rotated in any way.

<p class='image-block'>
    <img src='/public/images/eigenvector_scaling.png' width='300'/>
    Notice how $\lambda v$ is in the same direction as $v$. Image Source: Wikipedia.
</p>

<p class='highlight-block'>
In this sense, the eigenvectors of a linear map $f$ show us the axes along which the map simply scales or stretches its inputs.
</p>

The single best visualization I've seen of this is by 3Blue1Brown who has a fantastic [youtube channel](https://www.google.com/search?q=3blue1brown+youtube&oq=3blue1brown+youtube&aqs=chrome.0.0l6.2679j0j7&sourceid=chrome&ie=UTF-8) on visualizing math in general.

I'm embedding his video on eigenvectors and their visualizations below as it is the best geometric intuition out there:

<p style='display: flex; flex-direction: column; align-items: center; justify-content: center;'>
    <iframe width="560" height="315" src="https://www.youtube.com/embed/PFDu9oVAE-g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

    Source: <a href='https://www.google.com/search?q=3blue1brown+youtube&oq=3blue1brown+youtube&aqs=chrome.0.0l6.2679j0j7&sourceid=chrome&ie=UTF-8'>3Blue1Brown</a>
</p>
<hr />

### Google and Eigenvectors

Like we saw at the beginning of this post, eigenvectors are not just an abstract concept used by eccentric mathematicians in dark rooms - they underpin some of the most useful technology in our lives including Google Search. For the brave, [here's](http://ilpubs.stanford.edu:8090/422/1/1999-66.pdf) Larry Page and Sergey's original paper on PageRank, the algorithm that makes it possible for us to type in a few letters on a search box and instantly find every relevant website on the internet.

In the [next post]({ post_url 2019-03-20-pagerank }), we're going to actually dig through this paper and see how eigenvectors are applied in Google search!

Stay tuned.

<hr />

### Appendix


Proof that $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$ span $R^2$:


1. We know already that ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ can be used to reach every coordinate.
2. We can create ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ by computing:
    - $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}} - \textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}} = {\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$
3. Thus we can combine our vectors to obtain both ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. By point 1, this means every vector in $R^2$ is reachable by combining $\textcolor{blue}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.

{% endkatexmm %}
