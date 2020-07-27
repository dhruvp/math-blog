---
layout: post
title: Interactive Visualization of Why Eigenvectors Matter
comments: false

---

{% katexmm %}

You've probably heard the word eigenvectors hundreds of times in class and have been asked to calculate it hundreds more. But why is this concept so cecntral in Linear Algebra? Why is it that we study the eigenvector of a matrix so often?

In this post, we'll see how Eigenvectors help us immediately understand what a linear function will do to an input. We'll do so by playing with an interactive visualization that allows us to see just that.

### Quick Refresher

<p class='image-block'>
    <img src='/public/images/eigenvector_scaling.png' width='300'/>
    Here, applying $A$ on its eigenvector $v$ leades to a new vector $\lambda v$ is in the same direction as $v$. Image Source: Wikipedia.
</p>

Let's do a quick refresher to begin with. The eigenvector of a linear function A is just the vector $v$ s.t. $Av = \lambda v$ for some constant $\lambda$ which we call the eigenvalue. At a high level, the eigenvector is just a dimension along which the linear function only stretches its input (for real valued eigenvalues).

We also saw in a previous blog post (please check it out if you haven't yet!) how eigenvectors help us create a basis that represents the linear function as a diagonal matrix. This is great and all but what can we do once we get an Eigenvector?

### Linear Functions Pull Inputs Towards the Dominant Eigenvector

<p class='image-block'>
    <img src="/public/images/eigenvector_pull/setosa_visualization.png" />
    In the interactive visualization from Setosa.io, applying $A$ to the vector $v$ pulls $v$ towards the line $s_1$.
</p>

Let's start with some intuition. Please go to this link from [setosa.io](https://setosa.io/ev/eigenvectors-and-eigenvalues/) and try out the visualization that matches the above image. Get back when you've finished.

In the above example, $s_1$ is the eigenline for the eigenvector with eigenvalue $1.1$. This means it is the "axis" of that given eigenvector (i.e. you draw a line out from that eigenvector). Similarly, $s_2$ is the eigenline for the eigenvector with eigenvalue $0.5$. The red dots represent the result of applying $A$ on an input vector $v$. 

Notice how when you apply the linear function $A$ again and again ($A^2v, A^3v, ...$), the resulting vector ends up completely on $s_1$ - the axis of the first eigenvector.

This is really interesting as it indicates that just by knowing the eigenvector, and thereby eigenline $s_1$, we already have a sense of what $A$ does -  $A$ **pulls** its inputs towards $s_1$.

How is this happening? And why is it only towards $s_1$ and not $s_2$?

### Interactively Seeing Why Linear Functions "Pull" Towards the Dominant Eigenvector

You'll be surprised to see that this behavior comes very naturally from the properties of linear functions.  Let's see this with an example.

Say I have a linear function $A = \begin{bmatrix}3 & 2 \\ 1 & 4\end{bmatrix}$, and we wish to find out what happens when I apply $A$ three times on an input $v = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$ (i.e. $A^3v$).

<p class='image-block'>
    <img src='/public/images/eigenvector_pull/standard_flow.png' style="width: 50%;"/>
    In the standard way, we'd just use standard matrix multiplication to find $A^3v$.
</p>

The standard way to do this is to simply follow the rules of multiplication and carry out $A(A(A(v)))$. But as part of this exercise, let's do this a different way using eigenvectors.

<p class='image-block'>
    <img src='/public/images/eigenvector_pull/split_flow.png' />
    In the following discussion we will split $v$ into a linear combination of $A$'s eigenvectors. We then apply $A^3$ to each of these pieces and combine the result.
</p>

We know that that any vector $v$ can be written as the sum of the eigenvectors of $A$. After all, eigenvectors are linearly independent and form a basis for the space. If $v_1$ and $v_2$ are the eigenvectors of $A$, we can break up $v$ as:

$v = c_1 \cdot v_1 + c_2 \cdot v_2$ for some constants $c_1$ and $c_2$.

<p class='image-block'>
    <img src="/public/images/eigenvector_pull/split.png"  style="width: 30%"/>
    We first split $v$ into its eigenvector subcomponents.
</p>

When we have this representation, we can then rethink $A^3v$ as:

$$A^3v = A^3(c_1 \cdot v_1 + c_2 \cdot v_2)$$.

or more simply:

$$A^3v = c_1 \cdot A^3v_1 + c_2\cdot A^3v_2$$


<p class='image-block'>
    <img src="/public/images/eigenvector_pull/process.png" style="width: 30%"/>
    We then carry out $A^3v_1$ and $A_3v_2$.
</p>

We then carry out the computation of $A^3v_1$ and $A_3v_2$. Thanks to $v_1$ and $v_2$ being eigenvectors, this neatly simplifies to $A^3v = c_1 \lambda_1^3v_1 + c_2 \lambda_2^3v_2$ where $\lambda_1$ is the eigenvalue of $v_1$ and $\lambda_2$ is the eigenvalue of $v_2$.

<p class='image-block'>
    <img src="/public/images/eigenvector_pull/combine.png" style="width: 30%"/>
    We finally combine the results to get $A^3v$.
</p>

We then finally combine the results to get $A^3v$.


Now, what happens when $\lambda_1$ is larger than $\lambda_2$? Let's imagine $\lambda_1 = 5$ and $\lambda_2 = 2$. Let's now display what it would look like to carry out $A^3v$ when we have this difference in eigenvalues.


The interaction below shows this setup. 

{% include eigenvectors.html %}

1. Drag the slider to increase or decrease the number of times we apply $A$ on $v$.
2. Notice how "Output Eigenvector 1" and "Output Eigenvector 2" change at different rates.
3. Notice how "Final Output Vector" tilts towards "Output Eigenvector 1" as you drag the slider to the right.

We thus see that when there's one eigenvalue larger than the other ($\lambda_1 > \lambda_2$), the linear function pushes its inputs towards the eigenvector associated with that large eigenvalue ("Output EigenVector One"). The more times we apply $A$, the larger this effect.


The widget above took on the following real values:

$$A = \begin{bmatrix}3 & 2 \\ 1 & 4\end{bmatrix}$$

$$v_1 = \begin{bmatrix} 1 \\ 1 \end{bmatrix}$$

$$v_2 =  \begin{bmatrix} -2 \\ 1 \end{bmatrix}$$


### Why this happens

This tilt towards "Output Vector One" happens due to exponential growth. $\lambda_1^x$ grows much faster than $\lambda_2^x$. As such the more times we apply $A$ ($x$ in our exponentials), the bigger the difference between $\lambda_1^x$ and $\lambda_2^x$. This will tilt the sum towards the $\lambda_1^x$ term. This increasing difference is shown in the plots below.

<p class='image-block'>
    <img src='/public/images/eigenvector_pull/exponentials.png' />
    Due to the power of exponentials, the dominant eigenvector will play a bigger and bigger role the more times we apply A. Notice how the distance between the two expontial functions increases with x.
</p>

So knowing the largest eigenvalue $\lambda_1$ and its corresponding eigenvector $v_1$, we can know where a function will aim to push its inputs.

## Conclusion

So, just using the properties of linear functions, we are able to see why eigenvectors are so important they show us where a linear function will "push" its inputs. In doing so they give us immediate visual intuition for how a linear function will behave.

### Caveat

1. Everything I've discussed is for real eigenvalues.


#### Credits
Thanks to Luis Serrano, Pranav Ramakrishnan, and Daniel Hsu for feedback.

{% endkatexmm %}
