clc; clear; close all;

x  = linspace(-pi/2,pi/2,10);
xn = [-pi/2 0 pi/2]';

f = @(x)(cos(x))
V = vander(xn)
a = V\f(xn)
b = polyfit(x,f(x),2)

fI = polyval(a,x)
fL = polyval(b,x)

figure(1)
plot(x,fI,'--r','LineWidth',1,'DisplayName','Interpolation')
hold on
plot(x,f(x),'-k','LineWidth',1,'DisplayName','Original')
plot(x,fL,'-b','LineWidth',1,'DisplayName','Least Squares')
ylim([-0.1,1.1])
legend('Location','south','FontSize',12)

fprintf('Error in interpolation:')
disp(trapz(x,(fI-f(x)).^2))
fprintf('Error in least squares:')
disp(trapz(x,(fL-f(x)).^2))
fprintf('Trapz on actual function:')
disp(trapz(x,f(x)))
fprintf('Integral on actual function:')
disp(integral(f,-pi/2,pi/2))

fprintf('\nTrapz for a periodic function\n')
y = linspace(0,2*pi,10);
fprintf('Integral of sin^2 in 0 to 2*pi:')
disp(trapz(y,sin(y).^2))