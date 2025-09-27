%% X = [1x, 2y, 3z, 4v, 5gamma, 6psi]'
%% U = [mu, nx, nz]'
function DX = Dynamics(t,X,U)
%% Control (mu, nx, nz)
% mu = 0;
% U = [mu;0;1/(cos(mu))]';
mu = U(3);
ub = 45*pi/180;
lb = -ub;
if mu > ub
    mu = ub;
elseif mu < lb
    mu = lb;
end
nx = U(1);

nz = U(2);
nz = 1/(cos(X(5))*cos(mu)) + nz;

%% Dynamics
g = 9.81;
DX = zeros(length(X),1);
DX(1) = X(4)*cos(X(5))*cos(X(6));
DX(2) = X(4)*cos(X(5))*sin(X(6));
DX(3) = X(4)*sin(X(5));
DX(4) = g*(nx-sin((X(5))));
DX(5) = (g/X(4))*(nz*cos(mu)-cos(X(5)));
DX(6) = g*nz*(sin(mu))/(X(4)*cos(X(5)));
end