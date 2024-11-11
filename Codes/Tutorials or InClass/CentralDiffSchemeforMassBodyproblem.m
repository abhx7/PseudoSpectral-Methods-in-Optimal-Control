t0 = 0;
tf = 1;
N  = 200;
dt = (tf - t0)/(N-1);
BCs = [0,1,0,0]; %assigned when declaring itself

x_guess = linspace(0,1,N)';
v_guess = zeros(N,1);
u_guess = linspace(-1,1,N)';

X0 = [x_guess; v_guess; u_guess];


A=zeros(3*N);

A(1,1) = -1/dt;
A(1,2) = 1/dt;

%coefficient of x
for i=2:N-1
    A(i,i-1)=-0.5/dt;
    A(i,i+1)=0.5/dt;
    A(i,i+N)=-1;
end

A(N,N-1) = -1/dt;
A(N,N) = 1/dt;

A(1,N+1) = -1;
A(N,2*N) = -1;


%coefficient of v
A(N+1,N+1) = -1/dt;
A(N+1,N+2) = 1/dt;

for i=N+2:2*N-1
    A(i,i-1)=-0.5/dt;
    A(i,i+1)=0.5/dt;
    A(i,i+N)=-1;
end
A(2*N,2*N-1) = -1/dt;
A(2*N,2*N) = 1/dt;
A(N+1,2*N+1) = -1;
A(2*N,3*N) = -1;


b = zeros(4,3*N);
b(1,1) = 1; % initial x position = 0
b(2,N) = 1; % final x position = 1
b(3,N+1) = 1; % initial v = 0
b(4,2*N) = 1; % final v = 0
D = [A;b];


%X=2*dt*inv(A)*X

opts = optimoptions('fmincon','MaxIterations',1e3,'MaxFunctionEvaluations',1e5);
X = fmincon(@(X)cost(X,N), X0, [], [], D, [zeros(3*N,1);0;1;0;0], [],[],[],opts);
%% Plots
time = linspace(0,tf,N);

figure(1); clf;
hold on
grid on
xlabel('Time')
ylabel('X Coordinate')
plot(time,X(1:N))

figure(2); clf;
hold on
grid on
xlabel('Time')
ylabel('X Velocity')
plot(time,X(1+N:2*N))

figure(3); clf;
hold on
grid on
xlabel('Time')
ylabel('Control Input')
plot(time,X(1+2*N:3*N))

%% Cost
function y = cost(X,N)
    Uvec = X(2*N+1:3*N,1);
    y = Uvec'*Uvec;
end

