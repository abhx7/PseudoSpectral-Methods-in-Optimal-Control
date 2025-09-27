%% 2 Player Game Dynamics
function dS = Game_Dynamics(t,S,U_Traj,tspan,T_end)

% persistent U;
% if isempty(U)
%     U = U_traj;
% end
% %% MPC
% if MPC_Tag == 0
%     T_horizon = 5;
%     Number_of_Nodes = T_horizon*10;
%     T_nodes = chebyroots(Number_of_Nodes)*T_horizon/2 + T_horizon/2;
%     tspan = T_nodes;
%     U_Traj_nodes = fmincon(@(U_Traj_nodes) cost(S,U_Traj_nodes,tspan), U*ones(1,Number_of_Nodes));
%     U = lagrange()
% else
%     U_P = U;
% end

%% Pursuer
X_P = S(1:6);
N = length(U_Traj);
% T_end = tspan(end);
U = polyesti(t*2/T_end-1,U_Traj,tspan*2/T_end-1);
U_P = U;

%U_P = [0;0;1]; 
DX_P = Dynamics(t,X_P,U_P);

%% Evader
X_E = S(7:12);
mu = 0.3;
U_E = [0;0;mu];
DX_E = Dynamics(t,X_E,U_E);

%% dS
dS = [DX_P;DX_E];
end