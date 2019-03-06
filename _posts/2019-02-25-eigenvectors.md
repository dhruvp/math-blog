---
layout: post
title: Eigenvectors
comments: false

---
{% katexmm %}

In the last post, we developed an intuition for matrices. We found that they are just compact representations of linear maps and that adding and multiplying matrices are just ways of combining the underlying linear maps.

In this post, we're going to dive deeper into the world of linear algebra and cover eigenvectors. Eigenvectors are central to Linear Algebra and help us understand one of the important algorithms of all time - The original Page Rank algorithm that powers Google Search! So needless to say, they're an extremely powerful idea worth exploring further!

<p class='image-block'>
    <img src='https://upload.wikimedia.org/wikipedia/commons/9/96/Google_web_search.png' />
    The PageRank Algorithm that powers Google Search was built using eigenvectors.
</p>

In this post we're going to take a slightly different approach to understanding eigenvectors - we're going to try and derive them ourselves. So hang in there and wait for the big reveal - I promise it will be really exciting when it all comes together!

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

### Vector Notation Based on Bases

In all our notation so far, we've been implicitly working in the basis $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. Every time I wrote a vector ${\begin{bmatrix} \textcolor{blue}{c} \\ \textcolor{#228B22}{d} \end{bmatrix}}$, I was actually saying:

* The vector you get when you compute $\textcolor{blue}{c \cdot \begin{bmatrix} 1 \\ 0 \end{bmatrix}} + \textcolor{#228B22}{d \cdot \begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. It's just a simple shorthand for $c$ parts the <strong><span style='color: blue;'>first basis vector</span></strong> plus $d$ parts the <strong><span style='color: #228B22;'>second basis vector</span></strong>.

Now when I use a different basis, the meaning of this notation actually changes. Say my basis is $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$.

Then the vector $\begin{bmatrix} \textcolor{blue}{c} \\ \textcolor{#228B22}{d} \end{bmatrix}_{B}$ means:

* The vector you get when you compute: $\textcolor{blue}{c \cdot b_1} + \textcolor{#228B22}{d \cdot b_2}$.

### Matrix Notation Based on Bases

This similarly extends to matrices. Earlier, the matrix $F$ for the function $f$ was represented by:

$$F = \begin{bmatrix} f(\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}) & f(\textcolor{#228B22}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}) \end{bmatrix}$$

When I use the basis $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$, the first column now represents $f(\textcolor{blue}{b_1})$ and the second column represents $f(\textcolor{#228B22}{b_2})$. The matrix $F_{B}$ in basis $B$ becomes:

$$F_{B} = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix}$$

<hr />

### Choosing the Right Basis

We took this short detour into notation for a very specific reason - rewriting a matrix in a different basis is actually a neat trick that allows us to reconfigure the matrix to make it easier to use. How? Let's find out with a quick example.

Let's say I have a matrix $F$ (representing a linear function) that I need to apply again and again (say 5 times) on a vector $v$.

This would be:

 $F \cdot F \cdot F \cdot F \cdot F \cdot v$.

Usually, calculating this is really cumbersome.

<p class="image-block">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Matrix_multiplication_diagram_2.svg/313px-Matrix_multiplication_diagram_2.svg.png" />
Can you imagine doing this 5 times in a row? Yeesh.
</p>


But let's imagine for a moment that $F$ was a diagonal matrix (i.e. something like $F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $). If this were the case, then this multiplication would be EASY. If $F$ is diagonal, $F^{n} = \begin{bmatrix} a^n & 0 \\ 0 & b^n \end{bmatrix}$! Let's see it below:

$$F \cdot F = \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} \cdot \begin{bmatrix} a & 0 \\ 0 & b \end{bmatrix} $$
$$F \cdot F = \begin{bmatrix} a \cdot a + 0 \cdot 0 & a \cdot 0 + 0 \cdot b  \\ 0 \cdot a + b \cdot 0 & 0 \cdot 0 + b \cdot b \end{bmatrix}$$
$$F \cdot F =  \begin{bmatrix} a^2 & 0 \\ 0 & b^2 \end{bmatrix} $$

So how can we get $F$ to be a diagonal matrix?

<hr />

### Which Basis makes a Matrix a Diagonal Matrix?

Earlier, we saw that choosing a new basis makes us change how we write down the matrix. Can we extend this idea to choose some basis $B$ which actually allows us to write $F_{B}$ as a diagonal matrix?

From earlier, we know that

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix}$$

For this to be diagonal, we must have:

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix} = \begin{bmatrix} \lambda_1 & 0 \\ 0 & \lambda_2  \end{bmatrix}$$

for some $\lambda_1$ and $\lambda_2$ (i.e. the the top-right and bottom-left elements are $0$).

This implies:

1. $f(\textcolor{blue}{b_1}) =  {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_B$.
2. $f(\textcolor{#228B22}{b_2}) = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_B$.

Recall our discussion on vector notation in a different basis:

>Say my basis is $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$.
>Then the vector $\begin{bmatrix} c \\ d \end{bmatrix}_{B}$ means:
>* The vector you get when you compute: $c \cdot \textcolor{blue}{b_1} + d  \cdot \textcolor{#228B22}{b_2}$.

This means that in the basis $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$,

$$f(\textcolor{blue}{b_1}) = {\begin{bmatrix}\lambda_1 \\ 0 \end{bmatrix}}_B = \lambda_1 \cdot \textcolor{blue}{b_1} + 0 \cdot \textcolor{#228B22}{b_2} = \mathbf{\lambda_1 \cdot \textcolor{blue}{b_1}}$$
$$f(\textcolor{#228B22}{b_2}) = {\begin{bmatrix}0 \\ \lambda_2 \end{bmatrix}}_B = 0 \cdot \textcolor{blue}{b_1} + \lambda_2 \cdot \textcolor{#228B22}{b_2} = \mathbf{\lambda_2 \cdot \textcolor{#228B22}{b_2}}$$

So the answer is yes! if we can find a $B = \{\textcolor{blue}{b_1}, \textcolor{#228B22}{b_2}\}$ that satisfies the above properties, $F$ can be rewritten as $F_{B}$ which is a diagonal matrix!

<hr />

### Enter Eigenvectors

The vectors $\textcolor{blue}{b_1}$ and $\textcolor{#228B22}{b_2}$ we've discussed are **exactly the eigenvectors of $f$**. The eigenvectors of a matrix $F$ are the exact basis vectors that make $F_{B}$ a diagonal matrix.


More formally, we define an eigenvector of $f$ as any vector $v$ such that:

$$f(v) = \lambda v $$

or

$$F \cdot v = \lambda v $$

<p class='highlight-block'>
Once we switch to using the eigenbasis (basis of eigenvectors), our original problem of finding $f\circ f\circ f \circ f \circ f (v)$ becomes:

$$F_{B} \cdot F_{B} \cdot F_{B} \cdot F_{B} \cdot F_{B} \cdot v_{B}$$
$$ {\begin{bmatrix} {\lambda_1}^5 & 0 \\ 0 & {\lambda_2}^5 \end{bmatrix}}_{B} $$

**Using the eigenvector basis makes this problem trivial.**
</p>

<hr />

### An Example

Let's work through a full example of rewriting a matrix in its eigenbases to see this in action. Imagine we had the matrix $F = \begin{bmatrix}2 & 1 \\ 1 & 2 \end{bmatrix}$. Since the goal of this post is not learning how to *find* eigenvectors, I'm just going to give you the eigenvectors for this matrix. They are:

$$b_{1} = \begin{bmatrix} 1 \\ -1 \end{bmatrix}$$
$$b_{2} = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$

What is $F_{B}$, the matrix $F$ written in the basis $B=\{b_1, b_2\}$?

Since $F_B = \begin{bmatrix} f(\textcolor{blue}{b_1}) & f(\textcolor{#228B22}{b_2}) \end{bmatrix}$, we need to find :
- $f(\textcolor{blue}{b_1})$ and $f(\textcolor{#228B22}{b_2})$

$f(\textcolor{blue}{b_1})$ is:

$$ f(\textcolor{blue}{b_1}) = F\cdot \textcolor{blue}{b_1} = \begin{bmatrix}2 & 1 \\ 1 & 2\end{bmatrix} \cdot \begin{bmatrix} 1 \\ -1 \end{bmatrix}$$
$$ f(\textcolor{blue}{b_1}) = \begin{bmatrix} -1 \\ 1 \end{bmatrix}$$


Similarly,

$$ f(\textcolor{#228B22}{b_2}) = F\cdot \textcolor{#228B22}{b_2} = \begin{bmatrix}2 & 1 \\ 1 & 2\end{bmatrix} \cdot \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$
$$ f(\textcolor{#228B22}{b_2}) = \begin{bmatrix} 3 \\ 3 \end{bmatrix}$$

#### Writing $F_{B}$

We've now found $f(b_1)$ and $f(b_2)$. We need to rewrite these vectors in the notation for our new basis $B$.

What's $f(b_1)_{B}$?

$$f(b_1) = \begin{bmatrix} -1 \\ 1 \end{bmatrix} = \textcolor{blue}{-1} \cdot b_1 + \textcolor{#228B22}{0} \cdot b_2$$
$$f(b_1)_{B} = \begin{bmatrix} \textcolor{blue}{-1} \\ \textcolor{#228B22}{0} \end{bmatrix}$$

Similarly
$$f(b_2) = \begin{bmatrix} 3 \\ 3 \end{bmatrix} = \textcolor{blue}{0} \cdot b_1 + \textcolor{#228B22}{3} \cdot b_2$$ $$f(b_2)_{B} = \begin{bmatrix} \textcolor{blue}{0} \\ \textcolor{#228B22}{3} \end{bmatrix}$$

<p class='highlight-block'>
Putting this all together,

$$F_B = \begin{bmatrix} f(\textcolor{blue}{b_1})_{B} & f(\textcolor{#228B22}{b_2})_{B} \end{bmatrix}$$
$$F_B = \begin{bmatrix} -1 & 0 \\ 0 & 3 \end{bmatrix}$$

So we get the nice diagonal we wanted!
</p>

### Geometric Interpretation of Eigenvectors

Eigenvectors also have extremely interesting geometric properties worth understanding. To see this, let's go back to the definition for an eiegenvector of a linear map $f$ and its matrix $F$.

An eigenvector, is a vector $v$ such that:

$$F \cdot v = \lambda v $$

How are $\lambda v$ and $v$ related? $\lambda v$ is just a scaling of $v$ in the same direction - it can't be rotated in any way.

For instance, the following image shows $\begin{bmatrix} 2 \\ 1 \end{bmatrix}$, $2 \cdot \begin{bmatrix} 2 \\ 1 \end{bmatrix}$ and $3 \cdot \begin{bmatrix} 2 \\ 1 \end{bmatrix}$ all on the same graph. Notice how they all appear on the same line or axis.

INSERT IMAGE SHOWING EIGENVECTOR AS A SCALING.

<p class='highlight-block'>
In this sense, the eigenvectors of a linear map $f$ show us the axes along which the map simply scales or stretches its inputs.
</p>

INSERT IMAGE or VIDEO SHOWING EIGEN VECTOR SCALING/STRETCHING.

Note, there are some linear maps that rotate everywhere - take the linear map that rotates all its input by 90º. Such linear maps will clearly not purely scale on any input and will thus not have eigenvectors. So, **not all linear maps have eigenvectors**.

<hr />

### Google and Eigenvectors

Like we saw at the beginning of this post, eigenvectors are not just an abstract concept used by eccentric mathematicians in dark rooms - they underpin some of the most useful technology in our lives including Google Search. For the brave, here's Larry Page and Sergey's original paper on PageRank, the algorithm that makes it possible for us to type in a few letters on a search box and instantly find every relevant website on the internet.

In the next post, we're going to actually dig through this paper and see how eigenvectors are applied in Google search!

Stay tuned.

<hr />

### Appendix

Proof that $\textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$ span $R^2$:


1. We know already that ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ can be used to reach every coordinate.
2. We can create ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ by computing:
    - $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}} - \textcolor{blue}{\begin{bmatrix} 1 \\ 0 \end{bmatrix}} = {\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$
3. Thus we can combine our vectors to obtain both ${\begin{bmatrix} 1 \\ 0 \end{bmatrix}}$ and ${\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$. By point 1, this means every vector in $R^2$ is reachable by combining $\textcolor{blue}{\begin{bmatrix} 0 \\ 1 \end{bmatrix}}$ and $\textcolor{#228B22}{\begin{bmatrix} 1 \\ 1 \end{bmatrix}}$.


{% endkatexmm %}