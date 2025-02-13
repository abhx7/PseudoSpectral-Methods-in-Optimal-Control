N=100;
x = linspace(-1, 1, N); % Define x values
x0 = -1; % Define x0
x1 = 1;  % Define x1

%%interpolating a quadratic fucntion
p2 = [1, 2, 3]; % Coefficients for the quadratic polynomial
f2 = @(x) polyval(p2, x); % Define f2 as the quadratic polynomial function

% Define the interpolated function f1 using linear interpolation
f1 = @(x) f2(x0) * (x1 - x) / (x1 - x0) + f2(x1) * (x - x0) / (x1 - x0);

figure(1)
title('Linear Interpolation of Quadratic Function')
plot(x,f1(x),'--r','LineWidth',1,'DisplayName','Interpolation')
hold on
plot(x,f2(x),'-k','LineWidth',1,'DisplayName','Original')
legend('Location','south','FontSize',12)
hold off;

% Calculate and display the interpolation error
error = trapz(x, (f1(x) - f2(x)).^2);
fprintf('Error in interpolation (trapz method): %f\n', error);
figure(2);
plot(x,(f1(x)-f2(x)),'LineWidth',1,'DisplayName','Interpolation');
title('Quadratic Error')

max_J1 = [];max_J2 = [];
mse_J1 = [];mse_J2 =[];
% Parameterize y
for y=linspace(0,1,N)
    x0 = -y; % Set x0 as -y
    x1 = y;  % Set x1 as y
    
    % Define the interpolated function f1 using linear interpolation
    f1 = @(x) f2(x0) * (x1 - x) / (x1 - x0) + f2(x1) * (x - x0) / (x1 - x0);

    % Compute the functions J1 and J2
    J1 =  @(x) (x - x0) .* (x - x1);       
    J2 =  @(x) ((x - x0) .* (x - x1)).^2;     

    % Find the maximum absolute error for J1 and J2
    max_J1 = [max_J1  max(abs(J1(x)))];
    max_J2 = [max_J2  max(J2(x))];

    %MSE for J1 and J2
    mse_J1 = [mse_J1  mean(abs(J1(x)))];
    mse_J2 = [mse_J2  mean(J2(x))];
end 

yn=linspace(0,y,length(max_J1));
figure(3);
plot(yn,max_J1)
title('Max Error J1(y) = (x-x0)(x-x1), where x0=-y,x1=y')
% the results
[m1,i1]=min(max_J1);
fprintf('Max Error: Min error of all J1(x0, x1): %f\n', m1)
fprintf('at %f\n',yn(i1));


figure(4);
plot(yn,mse_J1)  
title('Mean Squared Error J1(y) = [(x-x0)(x-x1)], where x0=-y,x1=y')
% the results
[m2,i2]=min(mse_J1);
fprintf('MSE: Min error of all J1(x0, x1): %f\n', m2)
fprintf('at %f\n',yn(i2));


