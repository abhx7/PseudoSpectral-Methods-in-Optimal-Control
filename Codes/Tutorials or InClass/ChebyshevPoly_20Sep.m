N = 5;
xn = linspace(-1, 1, 100);

Tf = zeros(1,N+1);

%% Plot the Chebyshev Polynomials (using cosine definition)
figure(1);  % Create a new figure for Chebyshev polynomials
hold on;  % Enable hold at the beginning, once for this figure

for i = 1:N+1
    % Compute the Chebyshev polynomial T_i(x) using cos definition
    T = cos(i * acos(xn));

    % Plot the Chebyshev polynomial
    plot(xn, T, 'DisplayName', ['T_{', num2str(i), '}']);
    
    % Compute the Chebyshev nodes xk for plotting
    xk = cos((2 * (1:i) - 1) * pi / (2 * i));
    
    % Plot the xk points as circles
    plot(xk, zeros(size(xk)), 'o');
    
    % Label the xk points
    for j = 1:length(xk)
        text(xk(j), 0, ['x_k', num2str(j)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end

    T_func = @(x) cos(i*acos(x));
    i
    fprintf('Trapz integration: ')
    disp(trapz(xn,T))
    fprintf('Integral integration: ')
    integral(T_func,-1,1)
    
    Tf(i) = integral(T_func,-1,1);

    % Compute the Chebyshev nodes xk for plotting
    xk = cos((2 * (1:i) - 1) * pi / (2 * i));
end

hold off;  % Disable hold after all plotting is done
legend('show');
xlabel('x');
ylabel('T_k(x)');
title('Chebyshev Polynomials');


% Compute the Chebyshev nodes xk for plotting
xk = cos((2 * (1:N+1) - 1) * pi / (2 * (N+1)));
f = zeros(1,N+1);
X = zeros(N+1);

f(1) = pi;
X(1,:) = xk
for j=1:N
    fun = @(y) power(cos(y),2*j-1)
    f(j+1) = integral(fun,0,pi)
    X(j+1,:) = xk.^(2*j-1)
end
w = X\f'
X\Tf'
