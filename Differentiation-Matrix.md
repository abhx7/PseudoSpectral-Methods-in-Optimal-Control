# Differentiation Matrix using Chebyshev Nodes

This document explains the derivation of the differentiation matrix based on Chebyshev nodes, which is useful for pseudospectral methods, interpolation, and solving boundary value problems.

## 1. Lagrange Polynomials

Given \( n+1 \) Chebyshev nodes \( x_0, x_1, \dots, x_n \) (often taken as \( x_j = \cos\left(\frac{j\pi}{n}\right) \), \( j = 0, 1, \dots, n \)), the Lagrange polynomial \( L_k(x) \) associated with each node is defined as:

\[
L_k(x) = \prod_{\substack{0 \leq j \leq n \\ j \neq k}} \frac{x - x_j}{x_k - x_j}.
\]

Each \( L_k(x) \) is a polynomial of degree \( n \) that satisfies:

\[
L_k(x_j) = \delta_{kj} =
\begin{cases}
1 & \text{if} \ j = k, \\
0 & \text{if} \ j \neq k.
\end{cases}
\]

## 2. Derivative of Lagrange Polynomials

To obtain the differentiation matrix, we need to differentiate \( L_k(x) \), which can be written as:

\[
L_k'(x) = \sum_{\substack{0 \leq j \leq n \\ j \neq k}} \left( \prod_{\substack{0 \leq m \leq n \\ m \neq k, m \neq j}} \frac{x - x_m}{x_k - x_m} \right) \cdot \frac{1}{x_k - x_j}.
\]

This gives the derivative of the Lagrange polynomial \( L_k(x) \), but we are primarily interested in evaluating it at the Chebyshev nodes \( x_i \).

### 2.1. Derivative at the Chebyshev Nodes

For Chebyshev nodes, we can simplify the derivative at node \( x_i \) (for \( i \neq k \)) as:

\[
L_k'(x_i) = \frac{(-1)^{i+k}}{x_i - x_k} \cdot \frac{c_i}{c_k}, \quad i \neq k,
\]

where:
- \( c_i = 2 \) for \( i = 0 \) and \( i = n \),
- \( c_i = 1 \) for all other nodes.

For the *diagonal entries* where \( i = k \), the derivative is:

\[
L_k'(x_k) = -\sum_{j \neq k} L_k'(x_j).
\]

## 3. The Differentiation Matrix

We can now assemble the differentiation matrix \( D \) using the formulas above:

- For \( i \neq j \):

\[
D_{ij} = \frac{(-1)^{i+j}}{x_i - x_j}, \quad i \neq j,
\]

- For diagonal entries \( i = j \):

\[
D_{ii} = -\sum_{j \neq i} D_{ij}.
\]

This differentiation matrix can then be used for numerical differentiation of functions sampled at Chebyshev nodes.


### Example Code

Here’s an example code in MATLAB to compute the differentiation matrix for Chebyshev nodes:

```matlab
function D = chebyshev_diff_matrix(n)
    % Compute the Chebyshev nodes
    x = cos(pi*(0:n)/n)';
    
    % Compute the differentiation matrix
    c = [2; ones(n-1,1); 2].*(-1).^(0:n)';
    X = repmat(x,1,n+1);
    dX = X - X' + eye(n+1);
    D  = (c*(1./c)')./(dX + eye(n+1));
    
    % Set the diagonal elements
    D = D - diag(sum(D,2));
end
