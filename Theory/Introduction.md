# Pseudo Spectral Methods for Optimal Control

Pseudo Spectral Methods for optimal control are a class of numerical techniques used for solving optimal control problems by approximating the state and control variables using spectral methods.

## Spectral Methods and Pseudospectral Methods

### Spectral Methods

**Definition**: Spectral methods are numerical techniques used for solving differential and integral equations by expanding the solution in terms of globally defined basis functions, such as orthogonal polynomials or trigonometric functions.

#### Core Idea
The core idea is to represent the solution \( u(x) \) as a series:
\[
u(x) \approx \sum_{n=0}^{N} a_n \phi_n(x),
\]
where \( \phi_n(x) \) are the chosen basis functions, and \( a_n \) are coefficients determined by projecting the original problem onto the basis functions.

#### Types of Spectral Methods
- **Fourier Spectral Method**:
  - **Basis Functions**: Trigonometric functions such as sine and cosine.
  - **Application**: Best suited for problems with periodic boundary conditions.
  - **Formulation**:
    \[
    u(x) \approx \sum_{k=-N/2}^{N/2} \hat{u}_k e^{ikx},
    \]
    where \( \hat{u}_k \) are the Fourier coefficients.

- **Polynomial Spectral Method**:
  - **Basis Functions**: Orthogonal polynomials, e.g., Chebyshev or Legendre polynomials.
  - **Application**: Suitable for non-periodic boundary conditions.
  - **Formulation**:
    \[
    u(x) \approx \sum_{n=0}^{N} a_n \phi_n(x),
    \]
    where \( a_n \) are coefficients found through projection.

#### Advantages and Disadvantages
- **Advantages**:
  - High accuracy for smooth problems (exponential convergence).
  - Efficient for global behavior of solutions.
- **Disadvantages**:
  - Not well-suited for non-smooth solutions.
  - More complex for problems with sharp discontinuities.

### Pseudospectral Methods

**Definition**: Pseudospectral methods approximate derivatives and solve differential equations by evaluating the function at selected collocation points, instead of directly manipulating the coefficients in the basis function expansion.

#### Core Idea
The function \( u(x) \) is expanded similarly to spectral methods:
\[
u(x) \approx \sum_{n=0}^{N} a_n \phi_n(x).
\]
However, the derivatives are computed at discrete points, known as collocation points, leading to a practical discretization.

#### Collocation Points
Common choices for collocation points include:
- **Chebyshev Nodes**:
  \[
  x_k = \cos\left(\frac{2k - 1}{2N} \pi\right), \quad k = 1, 2, \dots, N.
  \]
- **Gauss-Lobatto Points**: Nodes used for polynomial interpolation, chosen to enhance numerical stability and minimize errors.

#### Types of Pseudospectral Methods
- **Fourier Pseudospectral Method**:
  - Utilizes FFT for fast computation.
  - Ideal for periodic problems.
- **Chebyshev Pseudospectral Method**:
  - Uses Chebyshev polynomials and their nodes for derivatives.
  - Suitable for non-periodic problems.

#### Formulation
For a function \( u(x) \) and its derivative \( u'(x) \), the derivative at collocation points \( x_k \) can be approximated as:
\[
u'(x_k) \approx \sum_{j=0}^{N} D_{kj} u(x_j),
\]
where \( D_{kj} \) is the differentiation matrix based on the basis functions.

#### Advantages and Disadvantages
- **Advantages**:
  - Flexible for complex boundary conditions.
  - High accuracy, similar to spectral methods, with a practical approach to discretization.
- **Disadvantages**:
  - Computational cost due to dense matrix operations.
  - Sensitive to the choice of collocation points.

### Comparison Between Spectral and Pseudospectral Methods
- **Approach to Differentiation**:
  - **Spectral Methods**: Operate in the spectral space by manipulating expansion coefficients.
  - **Pseudospectral Methods**: Operate in the physical space by evaluating derivatives at collocation points.
- **Flexibility**:
  - **Spectral Methods**: Less flexible for complex boundaries.
  - **Pseudospectral Methods**: More adaptable for varied boundary conditions.
- **Implementation**:
  - **Spectral Methods**: Require exact integration for coefficient projection.
  - **Pseudospectral Methods**: Use discrete points and fast algorithms like FFT.

## Introduction
Pseudospectral methods are a class of numerical techniques used primarily for solving differential equations, particularly in the context of optimal control problems and partial differential equations. They combine the strengths of spectral methods and finite difference methods. Spectral methods approximate the solution to a differential equation by expressing it as a sum of global basis functions, typically orthogonal polynomials like Chebyshev polynomials or trigonometric functions. Pseudospectral methods are a specific type of spectral method where the differential equation is enforced at a set of discrete points in the domain, known as collocation points.

The concepts of direct and indirect methods are widely used in optimal control theory and numerical optimization. The two approaches differ fundamentally in the sequence in which they handle the discretization and optimization processes. In direct methods, the problem is first discretized and then optimized.

In this course, we will be using direct methods with a major focus on the discretization part.

## Important Terms
Brief introduction to the important terms we will be using in the discussions.

### Optimal Control Problem
Components of an Optimal Control Problem:
1. **State Variables** \(x(t)\): These describe the state of the system at any time \(t\). The evolution of these states is typically governed by differential equations.
2. **Control Variables** \(u(t)\): These are the inputs or decisions that can be manipulated over time to influence the behavior of the state variables.
3. **Dynamics (State Equations)**:
   \[
   \dot{x}(t) = f(x(t), u(t), t)
   \]
   This is a set of differential equations describing how the state variables evolve over time as a function of the current state, control inputs, and time.
4. **Cost Function (Objective Function)**:
   \[
   J = \int_{t_0}^{t_f} L(x(t), u(t), t)\, dt + \Phi(x(t_f))
   \]
   Here, \(L(x(t), u(t), t)\) is the running cost (instantaneous cost rate), and \(\Phi(x(t_f))\) is the terminal cost at the final time \(t_f\). The goal is to minimize (or maximize) this cost function.
5. **Boundary Conditions**:
   \[
   x(t_0) = x_0 \quad \text{and possibly} \quad x(t_f) = x_f
   \]
   These specify the initial state (and sometimes the final state) of the system.
6. **Constraints**: These can include state constraints, control constraints, and mixed constraints.
   - **State Constraints**: \(g(x(t)) \leq 0\)
   - **Control Constraints**: \(h(u(t)) \leq 0\)
   - **Mixed Constraints**: Involving both state and control variables.
