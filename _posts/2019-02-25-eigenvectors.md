---
layout: post
title: Eigenvectors
comments: false

---
{% katexmm %}

In the last post, we developed an intuition for matrices. We found that they are just compact representations of linear maps and that adding and multiplying matrices are just a way of combining the underlying linear maps.

In this post, we're going to dive deeper into the world of linear algebra and cover one of the most important concepts in the space - eigenvectors. Eigenvectors are the foundation of one of the most important algorithms of all time - The original Page Rank algorithm that powers Google Search! Google uses Eigenvectors to rank all the webpages on the internet based on your search to return you the most relevant results. So needless to say, they're an extremely powerful idea and worth exploring further!

Unlike your traditional math textbook, we're going to avoid the standard method of defining eigenvectors formally and then slowly explaining what they're about. Instead, we're going to try and discover them for ourselves as if we never heard about this concept before. So hang in there and wait for the big reveal - I promise it will be really exciting when it all comes together!

Everything we'll be doing is going to be in the 2D space $R^2$ - the standard coordinate plane over real numbers you're probably already used to.

#### Basis Vectors

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

More formally, when two vectors are able to combine in different ways to create all other vectors in $R^2$, we say that those vectors form a **basis** for the space (*note the formal definition has a few more pieces and you can read it [here](). I'm taking some liberties in using a much simpler, albeit incomplete, definition*).

So, $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ are **basis vectors for $R^2$**.

You can think of basis vectors as building blocks for the space. We can combine them in different amounts to reach all vectors we could care about.

INSERT LEGO IMAGE

<hr />

#### Other Basis Vectors for $R^2$

Now are there other pairs of vectors that also form a basis for $R^2$? Namely, are there other pairs of vectors that we can combine to reach all possible vectors in the space?

Let's start with an example that definitely won't work.

#### Bad Example
$\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} -1 \\ 0 \end{bmatrix}}$.

Can you combine these vectors to create ${\begin{bmatrix} 2 \\ 3 \end{bmatrix}}$? Clearly you can't - we don't have any way to move in the $y$ direction.

<p class='image-block'>
    <img src='/public/images/bad_basis.png' />
    No combination of these two vectors could possible get us the vector $P$.
</p>

#### Good Example
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

In fact, we can reach every coordinate on the grid by combining our two vectors. Here's a simple way of proving this:

1. We know already that ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ can be used to reach every coordinate.
2. We can create ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ by computing:
    - $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}} - \textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}} = {\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$
3. Thus we can combine our vectors to obtain both ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. By point 1, this means every vector in $R^2$ is reachable by combining $\textcolor{blue}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.

So we've already seen something very cool:

**There are multiple valid bases for $R^2$.**

<hr />

#### Vector Notation based on Bases

Let's take a short aside on notation (sigh). This will become really important when we finally hit Eigenvectors.

In all our notation so far, we've been implicitly working in the basis $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. Every time I wrote a vector ${\begin{bmatrix} c \\ d \end{bmatrix}}$, I was actually saying:

* The vector you get when you compute $c \cdot \textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}} + d \cdot \textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. It's just a simple shorthand for $c$ parts the <strong><span style='color: blue;'>first basis vector</span></strong> plus $d$ parts the <strong><span style='color: #228B22;'>second basis vector</span></strong>.

Now when I use a different basis, the meaning of this notation actually changes. Say my basis is $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$.

Then the vector $\begin{bmatrix} c \\ d \end{bmatrix}_{B}$ means:

* The vector you get when you compute: $c \cdot \textcolor{blue}{b_1} + d  \cdot \textcolor{#228B22}{b_2}$.

#### Matrix Notation based on Bases

This similarly extends to matrices. Earlier, the matrix $F$ for the function $f$ was represented by:

$$\begin{bmatrix} f(\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}) & f(\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}) \end{bmatrix}$$

When I use the basis $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$, the first column now represents $f(\textcolor{blue}{b_1})$ and the second column represents $f(\textcolor{#228B22}{b_2})$. The matrix $F$ in basis $B$ becomes:

$$\begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix}$$

<hr />

#### Choosing the Right Basis

We took this short detour into notation for a very specific reason - rewriting a matrix in a different basis is actually a neat trick for allowing us to manipulate the matrix far more easily.

To see why, imagine I have a linear map $f$ that represents how a rocket's trajectory changes in 2D space when you turn on the boosters.

INSERT ROCKET IMAGE

 Let's say I really need to find out what happens when I turn on the booster $5$ times in a row when the rocket is at a vector $v$. This is the same as finding (i.e. $f \circ f \circ f \circ f \circ f(v)$). How would I do this?

INSERT IMAGE OF F APPLIED 5 TIMES

 As we saw in the last post, this is the same as using the matrix $F$ and calculating:

 $F \cdot F \cdot F \cdot F \cdot F \cdot v$.

Imagine that $F$ is:

$$F = \begin{bmatrix} 2 & 0 \\ 2 & 2 \end{bmatrix} $$

Calculating  $F \cdot F \cdot F \cdot F \cdot F \cdot v$ is pretty complicated and requires a lot of steps. Let's start with a simple question:


**1. Is there a way we could make this matrix multiplication super simple?**

Yes! If $F$ was a diagonal matrix (i.e. something like $F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $) this would be easy. Let's see it below:

$$F \cdot F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} \cdot \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $$
$$F \cdot F = \begin{bmatrix} a \cdot a + 0 \cdot 0 & a \cdot 0 + 0 \cdot b  \\ 0 \cdot a + b \cdot 0 & 0 \cdot 0 + b \cdot b \end{bmatrix}$$
$$F \cdot F =  \begin{bmatrix} a^2 & 0 \\ 0 & b^2 \end{bmatrix} $$

And similarly,

$$F \cdot F \cdot F \cdot F \cdot F =  \begin{bmatrix} a^5 & 0 \\ 0 & b^5 \end{bmatrix} $$

So this leads us to question 2:

**2. We saw earlier that the matrix for a linear map $f$ changes how we write out the matrix $F$. Is there any basis that allows me to write $F$ as a diagonal matrix?**

<hr />

#### Which Basis makes a Matrix a Diagonal Matrix?

Said another way, what basis $B = \{\textcolor{blue}{b1}, \textcolor{#228B22}{b2}\}$ makes $F$ a diagonal? Well, we know that

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix}$$

For this to be diagonal, we must have:

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix} = \begin{bmatrix} \lambda_1 & 0 \\ 0 & \lambda_2  \end{bmatrix}$$

for some $\lambda_1$ and $\lambda_2$.

This implies:

1. $f(\textcolor{blue}{b_1}) =  {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_B$.
2. $f(\textcolor{#228B22}{b_2}) = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_B$.

Recall our discussion on that the vector notation means in a different basis:

>Now when I use a different basis, the meaning of this notation actually changes. Say my basis is $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$.
>Then the vector $\begin{bmatrix} c \\ d \end{bmatrix}_{B}$ means:
>* The vector you get when you compute: $c \cdot \textcolor{blue}{b_1} + d  \cdot \textcolor{#228B22}{b_2}$.

This means that in the basis $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$,

$$f(\textcolor{blue}{b_1}) = {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_B = \lambda_1 \cdot \textcolor{blue}{b_1} + 0 \cdot \textcolor{#228B22}{b_2} = \mathbf{\lambda_1 \cdot \textcolor{blue}{b_1}}$$
$$f(\textcolor{#228B22}{b_2}) = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_B = 0 \cdot \textcolor{blue}{b_1} + \lambda_2 \cdot \textcolor{#228B22}{b_2} = \mathbf{\lambda_2 \cdot \textcolor{#228B22}{b_2}}$$


<hr />

#### Enter Eigenvectors

The vectors we've discussed $\textcolor{blue}{b_1}$ and $\textcolor{#228B22}{b_2}$ are exactly the **eigenvectors** of $f$. We define an eigenvector of $f$ as any vector $v$ such that:

$$f(v) = \lambda v $$

The eigenvectors of $f$ are the exact basis we need to represent $f$ as a diagonal matrix. Once we switch to using the eigenbasis (basis of eigenvectors), our original problem of finding $f\circ f\circ f \circ f \circ f (v)$ becomes:

$$F \cdot F \cdot F \cdot F \cdot F \cdot v$$
$$ \begin{bmatrix} {\lambda_1}^5 & 0 \\ 0 & {\lambda_2}^5 \end{bmatrix} $$

**So Eigenvectors are just the basis vectors that allow us to write the matrix $F$ as a diagonal.**

<hr />

##### Geometric Interpretation of Eigenvectors

Eigenvectors also have extremely interesting geometric properties worth understanding. To see this, let's go back to the definition for an eiegenvector of a linear map $f$ and its matrix $F$.

An eigenvector, is a vector $v$ such that:

$$F \cdot v = \lambda v $$

How are $\lambda v$ and $v$ related? $\lambda v$ is just a scaling of $v$ in the same direction - it can't be rotated in any way.

For instance, the following image shows $\begin{bmatrix} 2 \\ 1 \end{bmatrix}$, $2 \cdot \begin{bmatrix} 2 \\ 1 \end{bmatrix}$ and $3 \cdot \begin{bmatrix} 2 \\ 1 \end{bmatrix}$ all on the same graph. Notice how they all appear on the same line or axis.

INSERT IMAGE SHOWING EIGENVECTOR AS A SCALING.

In that sense, the eigenvectors of a linear map $f$ show us the axes along which the map simply scales or stretches its inputs.

INSERT IMAGE or VIDEO SHOWING EIGEN VECTOR SCALING/STRETCHING.

Note, there are some linear maps that rotate everywhere - take the linear map that rotates all its input by 90º. Such linear maps will clearly not purely scale on any input and will thus not have eigenvectors. So, **not all linear maps have eigenvectors**.

<hr />

#### Google and Eigenvectors

Like we saw at the beginning of this post, eigenvectors are not just an abstract concept used by eccentric mathematicians in dark rooms - they underpin some of the most useful technology in our lives including Google Search. For the brave, here's Larry Page and Sergey's original paper on PageRank, the algorithm that makes it possible for us to type in a few letters on a search box and instantly find every relevant website on the internet.

In the next post, we're going to actually dig through this paper and see how eigenvectors are applied in Google search!

Stay tuned.

{% endkatexmm %}