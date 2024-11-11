% Define number of Chebyshev nodes
n = 5; 

% Compute Chebyshev nodes
x_cheby = cos(pi * (1:2:2*n-1) / (2*n));  % Correct computation of Chebyshev nodes

% Transform Chebyshev nodes from [-1,1] to [0,1] for this problem
x_transformed = 0.5 * (x_cheby + 1);

% Get Chebyshev differentiation matrix and nodes
[D] = chebyshevDifferentiationMatrix(n, x_transformed);

% Define initial guess for u (linear guess between boundary conditions)
u_initial = linspace(0, 1, n)';  % Column vector because fsolve requires column vectors

% % Define the boundary conditions (equality constraints for fmincon)
Aeq = [1 zeros(1, n-1); zeros(1, n-1) 1];  % Boundary conditions matrix for u(0)=0 and u(1)=1
beq = [1; 0];  % Boundary values

% Set optimization options
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxFunctionEvaluations', 10000);

% Solve the optimization problem using fmincon
%u_solution = fmincon(@(u) cost_function(u, D), u_initial, [], [], [], [], [], [], @(u) bou1_conditions(u,D));
u_solution = fmincon(@(u) cost_function(u, D), u_initial, [], [], Aeq, beq, [], [], [], options);

% Analytical solution u(x) = sqrt(3x + 1) - 1
u_analytical = @(x) sqrt(3 * x + 1) - 1;
u_analytical_values = u_analytical(x_transformed);

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



% Cost function to minimize the residual squared
function cost = cost_function(u, D)
    % Residual function for the boundary value problem
    residual = (1 + u) .* (D^2* u) + (D * u).^2;
    
    % Cost is the sum of squared residuals
    cost = sum(residual.^2);
end

% Nonlinear constraint function for boundary conditions
function [c, ceq] = boundary_conditions(u,D)
    % No inequality constraints
    c = [];

    %res = (1 + u) .* (D^2*u) + (D * u).^2
    % Equality constraints: u(0) = 1 and u(1) = 0
    %ceq = [u(1) - 1; res(2:end-1) - 0  ; u(end) - 0];
    ceq = [u(1) - 1; u(end) - 0];
end

