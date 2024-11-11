n = 6;

x = linspace(0, 2*pi, 2*n + 1);

ak = zeros(1, n+1);
bk = zeros(1, n);

fx1 = x(1:ceil(end/2))/pi;
fx2 = 2 - x(ceil(end/2):end)/pi;

ak(1) = (trapz(x(1:ceil(end/2)),fx1) + trapz(x(ceil(end/2):end), fx2))/pi;

for i=1:n
    ak(i+1) = (trapz(x(1:ceil(end/2)),fx1.*cos(i*x(1:ceil(end/2)))) + trapz(x(ceil(end/2):end),fx2.*cos(i*x(ceil(ceil(end/2)):end))))/pi;
    bk(i) = (trapz(x(1:ceil(end/2)), fx1.*sin(i*x(1:ceil(end/2)))) + trapz(x(ceil(end/2):end),fx2.*sin(i*x(ceil(end/2):end))))/pi;
end

Snx = ak(1)/2;
for k=1:n
    Snx = Snx + ak(k+1)*cos(k*x) + bk(k)*sin(k*x);
end

%% Error:

fx = [fx1(1:end-1), fx2];
ex = (Snx - fx).^2;

%% Plots:

figure(1);
hold on;
xlabel('x', 'FontSize', 12);
ylabel('f(x)', 'FontSize', 12);
title('Fourier Series Approximation of the Function', 'FontSize', 14);
plot(x, fx, 'LineWidth', 3, 'DisplayName', 'Actual Function', 'Color', 'b');
plot(x, Snx, 'LineWidth', 2, 'DisplayName', 'Fourier Approximation', 'Color', 'r', 'LineStyle', '--');
legend('show');  
grid on;        
hold off;


figure(2)
plot(x, ex);