N = 10; % Number of nodes in the domain

xn = linspace(-1, 1, N*100); % Finer grid for plotting
xnodes = linspace(-1, 1, N); % Nodes in the domain

coefficient_range = [-10, 10]; % Define the range for coefficients
% Anonymous function to create a random polynomial
%f = @(x,n) polyval(randi(coefficient_range, 1, n+1), x);
f = @(x,n) x.^(n+1); % Define the polynomial term
%%syms x0
%%fprintf("%f",f(x0,N))

% Initialize the interpolation polynomial p(x)
p = zeros(1, length(xn));

%intitialise array to store absolute sum of Lks
sum_Lks = zeros(1,length(xn));

% Loop through each Lagrange basis polynomial
for k = 1:N
    xk = xnodes(k); % Current node
    Lk = ones(1, length(xn)); % Initialize Lk as a 1D array

    % Compute the Lagrange basis polynomial Lk(x)
    for i = 1:length(xn)
        Lk(i) = prod(xn(i) - [xnodes(1:k-1) xnodes(k+1:end)]) / prod(xk - [xnodes(1:k-1) xnodes(k+1:end)]);
        sum_Lks(i) = sum_Lks(i) + abs(Lk(i));
    end

    % Add the contribution of the current basis polynomial to the interpolation
    p = p + Lk * f(xk,N);

    % Compute the maximum of Lk
    Lks_max = max(Lk);
    fprintf("Maximum value of L_%d: %f \n", k, Lks_max);   

    % Plot the Lagrange basis polynomial
    plot(xn, Lk, 'DisplayName', ['L_{', num2str(k), '}']);
    hold on;
end

hold off;
figure(1);
legend('show');
xlabel('x');
ylabel('L_k(x)');
title('Lagrange Basis Polynomials');
grid on;

% Compute the error at each point xn
error = p - f(xn,N);

% Plot the error
figure(2);
plot(xn, error, 'DisplayName', 'Error');
legend('show');
xlabel('x');
ylabel('Error');
title('Error in Lagrange Interpolation');
grid on;

figure(3);
plot(xn, sum_Lks, 'DisplayName', 'Sum L_k s');
xticks(xnodes)
legend('show');
xlabel('x');
ylabel('Sum of |L_k s|');
title('Sum over L_k for each point in the domain');
grid on;

