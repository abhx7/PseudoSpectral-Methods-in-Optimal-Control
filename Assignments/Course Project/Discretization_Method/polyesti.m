function y = polyesti(t,U_Traj,tstep)
y = zeros(3,1);
n = length(tstep);
for i = 1:n
    y = y + U_Traj(:,i)*lagrange(t,tstep,i);
end
end