# Pseudospectral Methods in Optimal Control

Welcome to the repository for **Pseudospectral Methods in Optimal Control**. This repository contains my work and studies throughout my course on Pseudospectral Methods, focusing on topics ranging from interpolation to spectral methods and their application in optimal control.

## Repository Structure

The repository is organized into the following key topics, each with theoretical explanations, code examples, and related plots:

- **Interpolation**: Understanding interpolation methods, including Lagrange interpolation, Newton's divided difference, and Barycentric interpolation.
- **Orthogonal Polynomials**: Exploring the recurrence relations of Legendre, Chebyshev, and other orthogonal polynomials.
- **Optimal Control**: Methods for solving optimal control problems, including direct and indirect methods, and static Lagrange multipliers.
- **Spectral Methods**: A deep dive into Fourier series, Galerkin methods, and the application of spectral methods for solving boundary value problems.
- **Galerkin Method Error Analysis**: Deriving and analyzing the error terms when applying Galerkin methods.
- **Gauss-Jacobi Integration**: Numerical integration using Gaussian quadrature and Chebyshev nodes.
- **Bernstein Polynomials**: Studying the Bernstein polynomials and their role in uniform approximation.

Each folder contains:
- **Theory files (Markdown)**: Overview and detailed explanations of key concepts.
- **Python code files**: Implementations and computations in Python, along with generated plots to visualize the theoretical concepts.
- **Plots**: Visualizations of various mathematical concepts, functions, and results.

## Contents Overview

### 1. Interpolation
- **Interpolation Methods**: Learn about Lagrange interpolation, Newton's divided difference, and how the Vandermonde matrix is used in interpolation.  
  - Files: `interpolation_theory.md`, `vander_monde_matrix.py`.

### 2. Orthogonal Polynomials
- **Orthogonal Polynomials**: Explore the properties and recurrence relations of Legendre, Chebyshev, and other orthogonal polynomials.  
  - Files: `orthogonal_polynomials_theory.md`, `recurrence_relation.py`.

### 3. Optimal Control
- **Optimal Control Theory**: Focus on static Lagrange multipliers, and the direct and indirect methods used in solving optimal control problems.  
  - Files: `optimal_control_theory.md`, `static_lagrange_multipliers.py`.

### 4. Spectral Methods
- **Spectral Methods**: Discuss the Fourier series, Galerkin projection method, and their application in solving boundary value problems.  
  - Files: `spectral_methods_theory.md`, `fourier_series.py`.

### 5. Galerkin Method Error Analysis
- **Error Analysis in Galerkin Methods**: Analyze the error terms and stability of Galerkin approximations.  
  - Files: `galerkin_error_analysis.py`.

### 6. Gauss-Jacobi Integration
- **Gauss-Jacobi Integration**: Implement Gaussian quadrature and use Chebyshev nodes for numerical integration.  
  - Files: `gauss_jacobi_integration_theory.md`, `gauss_jacobi_method.py`.

### 7. Bernstein Polynomials
- **Bernstein Polynomials**: Study the uniform approximation properties of Bernstein polynomials.  
  - Files: `bernstein_polynomials_theory.md`.

## Instructions for Running Code

### Dependencies
The Python code requires the following libraries:
- `numpy`
- `scipy`
- `matplotlib`

You can install these using `pip`:

```bash
pip install numpy scipy matplotlib
