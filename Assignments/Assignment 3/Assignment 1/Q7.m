N = 30; % Number of nodes in the domain

% Function to create given polynomial
f = @(x) 1./(1 + x.^2); 

i1 = zeros(1, N-1);
i2 = zeros(1, N-1);
i3 = integral(f, -5, 5); % Analytical integral of the original function

for i = 2:N
    xnodes1 = linspace(-5, 5, i); % Uniform nodes in the domain
    xnodes2 = cos((2*(1:i) - 1) * pi / (2 * i)); % Chebyshev nodes (extrema of Chebyshev polynomial of the first kind)
    
    % Scale Chebyshev nodes to the [-5, 5] domain
    xnodes2 = 5 * xnodes2; 

    % Define interpolation polynomial p1 for Uniform nodes
    p1 = @(x) 0;
    for k = 1:i
        Lk1 = @(x) prod(bsxfun(@minus, x, [xnodes1(1:k-1), xnodes1(k+1:end)]), 2) / ...
                    prod(xnodes1(k) - [xnodes1(1:k-1), xnodes1(k+1:end)]);
        p1 = @(x) p1(x) + Lk1(x) * f(xnodes1(k));
    end
    
    % Define interpolation polynomial p2 for Chebyshev nodes
    p2 = @(x) 0;
    for k = 1:i
        Lk2 = @(x) prod(bsxfun(@minus, x, [xnodes2(1:k-1), xnodes2(k+1:end)]), 2) / ...
                    prod(xnodes2(k) - [xnodes2(1:k-1), xnodes2(k+1:end)]);
        p2 = @(x) p2(x) + Lk2(x) * f(xnodes2(k));
    end
    
    % Integrate using MATLAB's integral function with 'ArrayValued', true
    i1(i-1) = integral(p1, -5, 5, 'ArrayValued', true);
    i2(i-1) = integral(p2, -5, 5, 'ArrayValued', true);
end

i1(1)
i1(4)
i1(9)
i1(14)
i1(29)

i2(1)
i2(4)
i2(9)
i2(14)
i2(29)

i3(1)

% Plotting
Ns = linspace(2, N, N-1);

figure(1);
hold on;

% Plot with different line styles and markers for clarity
plot(Ns, i1, '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0, 0.4470, 0.7410]); % Uniform Nodes
plot(Ns, i2, '--s', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0.8500, 0.3250, 0.0980]); % Chebyshev Nodes
plot(Ns, i3 * ones(size(Ns)), '--', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0.9290, 0.6940, 0.1250]); % Analytical Integral

% Add a legend
legend('Uniform Nodes', 'Chebyshev Nodes', 'Analytical Integral', 'Location', 'Best');

% Axis labels and title with increased font size for readability
xlabel('Number of Nodes', 'FontSize', 12);
ylabel('Integral', 'FontSize', 12);
title('Integral of f(x) = 1/(1+x^2) over Domain [-5, 5]', 'FontSize', 14, 'FontWeight', 'Bold');

% Grid for better visibility
grid on;

% Set axis limits (optional)
%xlim([2, N]);
%ylim([min([i1 i2]) - 0.1*abs(min([i1 i2])), max([i1 i2]) + 0.1*abs(max([i1 i2]))]);

% Enhance the overall figure appearance
set(gca, 'FontSize', 12); % Increase font size for the axis labels and ticks
box on;

hold off;


% Plotting
Ns = linspace(2, N, N-1);

figure(2);
hold on;

% Plot with different line styles and markers for clarity
plot(Ns, abs(i3-i1), '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0, 0.4470, 0.7410]); % Uniform Nodes
plot(Ns, abs(i3-i2), '--s', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', [0.8500, 0.3250, 0.0980]); % Chebyshev Nodes

% Add a legend
legend('Uniform Nodes', 'Chebyshev Nodes','Location', 'Best');

% Axis labels and title with increased font size for readability
xlabel('Number of Nodes', 'FontSize', 12);
ylabel('Error of Integral', 'FontSize', 12);
title('Error of Integral of f(x) = 1/(1+x^2) over Domain [-5, 5]', 'FontSize', 14, 'FontWeight', 'Bold');

% Enhance the overall figure appearance
set(gca, 'FontSize', 12); % Increase font size for the axis labels and ticks
box on;

hold off;

