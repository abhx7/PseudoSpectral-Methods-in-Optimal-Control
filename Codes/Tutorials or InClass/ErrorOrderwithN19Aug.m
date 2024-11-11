N = 10; % Number of nodes in the domain

xn = linspace(-5, 5, N*100); % Finer grid for plotting
xnodes = linspace(-5, 5, N); % Nodes in the domain

%  function to create given polynomial
f = @(x) 1./(1 + x.^2); 

% Initialize the interpolation polynomial p(x)
p = zeros(1, length(xn));

% Loop through each Lagrange basis polynomial
for k = 1:N
    xk = xnodes(k); % Current node
    Lk = ones(1, length(xn)); % Initialize Lk as a 1D array

    % Compute the Lagrange basis polynomial Lk(x)
    for i = 1:length(xn)
        Lk(i) = prod(xn(i) - [xnodes(1:k-1) xnodes(k+1:end)]) / prod(xk - [xnodes(1:k-1) xnodes(k+1:end)]);
    end

    % Add the contribution of the current basis polynomial to the interpolation
    p = p + Lk * f(xk);

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
error = f(xn) - p;

% Plot the error
figure(2);
plot(xn, error, 'DisplayName', 'Error');
legend('show');
xlabel('x');
ylabel('Error');
title('Error in Lagrange Interpolation');
grid on;


N=30;
ey = zeros(1,N-1);
for i=2:N
    xnn = linspace(-5, 5, i*100); % Finer grid for plotting
    xnodes = linspace(-5, 5, i); % Nodes in the domain
    
    y = (xnn(i*100)+xnn(i*100-1))/2;
    
    % Initialize the interpolation polynomial p(x)
    p = zeros(1, length(xnn));
    
    % Loop through each Lagrange basis polynomial
    for k = 1:i
        xkk = xnodes(k); % Current node
        Lk = ones(1, length(xnn)); % Initialize Lk as a 1D array
    
        % Compute the Lagrange basis polynomial Lk(x)
        for j = 1:length(xnn)
            Lk(j) = prod(xnn(j) - [xnodes(1:k-1) xnodes(k+1:end)]) / prod(xkk - [xnodes(1:k-1) xnodes(k+1:end)]);
        end
    
        % Add the contribution of the current basis polynomial to the interpolation
        p = p + Lk * f(xkk);
    end
    
    % Compute the error at each point xn
    ey(i-1) = abs(f(y) - (p(i*100)+p(i*100-1))/2);
end

figure(3);
plot(linspace(2,N,N-1) , ey, 'DisplayName', 'Error');
legend('show');
xlabel('x');
ylabel('Error');
title('Error ');
grid on;
