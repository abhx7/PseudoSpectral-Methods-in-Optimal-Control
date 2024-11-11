N = 5;
xn = linspace(-1, 1, 100);

%% Plot the Chebyshev Polynomials (using cosine definition)
figure(1);  % Create a new figure for Chebyshev polynomials
hold on;  % Enable hold at the beginning, once for this figure

for i = 1:N
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
end

hold off;  % Disable hold after all plotting is done
legend('show');
xlabel('x');
ylabel('T_k(x)');
title('Chebyshev Polynomials');

%% Generate and plot Chebyshev polynomials using recurrence relation
figure(2);  % Create a new figure for recurrence relation-based polynomials
hold on;  % Enable hold at the beginning, once for this figure

% Initialize the first two Chebyshev polynomials
T0 = ones(size(xn));  % T_0(x) = 1
T1 = xn;  % T_1(x) = x

% Plot the first two Chebyshev polynomials
plot(xn, T0, 'DisplayName', 'T_0');
plot(xn, T1, 'DisplayName', 'T_1');

% Generate the higher-degree Chebyshev polynomials using the recurrence relation
for n = 2:N
    T_next = 2 * xn .* T1 - T0;  % Apply the recurrence relation
    
    % Plot the polynomial
    plot(xn, T_next, 'DisplayName', ['T_{', num2str(n), '}']);
    
    % Update T_{n-1} and T_n for the next iteration
    T0 = T1;
    T1 = T_next;
end

hold off;  % Disable hold after all plotting is done
legend('show');
xlabel('x');
ylabel('T_n(x)');
title('Chebyshev Polynomials using Recurrence Relation');

%% Plot the derivatives of Chebyshev polynomials
figure(3);  % Create a new figure for Chebyshev polynomial derivatives
hold on;  % Enable hold at the beginning, once for this figure

% Plot the derivative of T_1, which is constant 1
%plot(xn, 1, 'DisplayName', ['Tdiff_{', num2str(1), '}']);

for i = 2:N
    % Compute the derivative of T_i(x) using the formula for Chebyshev polynomial derivatives
    Tdiff = i * sin(i * acos(xn)) ./ sin(acos(xn));

    % Plot the derivative
    plot(xn, Tdiff, 'DisplayName', ['Tdiff_{', num2str(i), '}']);

    % Compute the Chebyshev derivative nodes xk for plotting
    xk = cos((1:i) * pi /i);
    
    % Plot the xk points as circles
    plot(xk, zeros(size(xk)), 'o');
    
    % Label the xk points
    for j = 1:length(xk)
        text(xk(j), 0, ['x_k', num2str(j)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
end

hold off;  % Disable hold after all plotting is done
legend('show');
xlabel('x');
ylabel('Tdiff_k(x)');
title('Chebyshev Diff Polynomials');

