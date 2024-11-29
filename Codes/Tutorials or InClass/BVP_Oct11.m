% Define number of Chebyshev nodes
n = 5; 

% Compute Chebyshev nodes
x_cheby = cos(pi * (1:2:2*n-1) / (2*n));  % Chebyshev nodes
x_cheby = x_cheby;

% Transform Chebyshev nodes from [-1,1] to [0,1] for this problem
a = 0;
b = 1;
x_transformed = (a+b)*0.5 + 0.5*(b-a)*x_cheby;

% Get Chebyshev differentiation matrix and nodes
[D] = chebyshevDifferentiationMatrix(n,x_transformed);


% Analytical solution u(x) = sqrt(3x + 1) - 1
u_analytical = @(x) (sqrt(3 * x + 1) - 1);
u_analytical_values = u_analytical(x_transformed);

% Define initial guess for u (linear guess between boundary conditions)
%u_initial = linspace(0, 1, n)';  % n because Chebyshev includes endpoints
u_initial = u_analytical_values';

% Define boundary conditions u(t=0) = 0, u(t=1) = 1 ==> u(-1) = 1, u(1) = 0
u_initial(1) = 1;
u_initial(end) = 0;


% Solve the nonlinear system using fsolve with boundary constraints
options = optimoptions('fsolve', 'Display', 'iter');  % Show iteration steps
u_solution = fsolve(@(u) residual_with_boundary(u, D), u_initial, options);


% Plot both the numerical and analytical solutions
figure;
plot(x_transformed, u_solution, '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'Numerical Solution');
hold on;
plot(x_transformed, u_analytical_values, '--', 'LineWidth', 1.5, 'DisplayName', 'Analytical Solution');
xlabel('x (transformed Chebyshev nodes)', 'FontSize', 12);
ylabel('u(x)', 'FontSize', 12);
title('Comparison of Numerical and Analytical Solutions', 'FontSize', 14);
legend('Location', 'Best');
grid on;


% Residual function for the boundary value problem, incorporating boundary conditions
function res = residual_with_boundary(u, D)
    % Keep boundary conditions fixed
    u(1) = 1;    % u(x=0) = 0  %%u(-1) = 1
    u(end) = 0;  % u(x=1) = 1  %% u(1) = 0
    
    % Calculate the residuals
    res = (1 + u) .* (D*D * u) + (D * u).^2;
    
    % Ensure boundary points remain unchanged
    res(1) = u(1) - 1;    
    res(end) = u(end) - 0; 

    res;
end