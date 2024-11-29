N = 10; % Number of nodes in the domain

xn = linspace(-1, 1, N*10); % Finer grid for plotting

% Chebyshev nodes (extrema of Chebyshev polynomial of the first kind)
xnodes = cos((2*(1:N) - 1) * pi / (2 * N));

f = @(x,n) x.^(n+1); % Define the polynomial term

% Initialize the interpolation polynomial p(x)
p = zeros(1, length(xn));

% Initialize array to store the absolute sum of Lks
sum_Lks = zeros(1, length(xn));

% Loop through each node to construct Lagrange basis polynomials
for k = 1:N
    % Construct the k-th Lagrange basis polynomial L_k(x)
    Lk = ones(1, length(xn));
    
    for j = [1:k-1, k+1:N]
        Lk = Lk .* (xn - xnodes(j)) / (xnodes(k) - xnodes(j));
    end
    
    % Accumulate the sum of |L_k(x)|
    sum_Lks = sum_Lks + abs(Lk);
    
    % Add the contribution of the current basis polynomial to the interpolation
    p = p + f(xnodes(k), N) * Lk;
    
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

% Plot the sum of the absolute values of L_k
figure(3);
plot(xn, sum_Lks, 'DisplayName', 'Sum |L_k s|');
xticks(sort(xnodes))
legend('show');
xlabel('x');
ylabel('Sum of |L_k s|');
title('Sum over |L_k| for each point in the domain');
grid on;
