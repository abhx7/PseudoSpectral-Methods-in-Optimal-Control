clear; clc

%% Time Stepping for a good Initial Guess

X0_P = [400,0,0,50,0,pi/4]';
X0_E = [50,50,0,50,0,1*pi/4]';
S0 = [X0_P;X0_E];
T_end = 30 ;
Tsim = linspace(0,T_end,T_end*1000);
NumberOfNodes = 40;
T_nodes = chebyroots(NumberOfNodes)*T_end/2 + T_end/2;
T_untransformed = chebyroots(NumberOfNodes);
U_Traj0 = [0;0;0]*ones(1,NumberOfNodes);

[t,S] = ode45(@(t,S)Game_Dynamics(t,S,U_Traj0,T_nodes,T_end),T_nodes,S0);

xp = S(:,1);
yp = S(:,2);
zp = S(:,3);
vp = S(:,4);
gammap = S(:,5);
psip = S(:,6);

xe = S(:,7);
ye = S(:,8);
ze = S(:,9);
ve = S(:,10);
gammae = S(:,11);
psie = S(:,12);

% figure(1); clf
% grid on 
% hold on
% title('Trajectory')
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% plot3(xp,yp,zp,'r',LineWidth=2)
% plot3(xe,ye,ze,'b',LineWidth=2)

Up0 = [zeros(3*NumberOfNodes,1)];
Ue0 = [zeros(3*NumberOfNodes,1)];
X0 = [xp;yp;zp;vp;gammap;psip;Up0];  
T0 = [xe;ye;ze;ve;gammae;psie;Ue0];

%% Differentiation Matrix

d = zeros(NumberOfNodes);

for i = 1:NumberOfNodes
    for j = 1:NumberOfNodes
        d(i,j) = dLagrange(T_untransformed(i),T_untransformed,j);
        
    end
end

d = d*2/T_end;

D_state = zeros(6*NumberOfNodes);
D_control = zeros(3*NumberOfNodes);
for i = 1:6
    if i<4
        D_control((i-1)*NumberOfNodes+1:i*NumberOfNodes,(i-1)*NumberOfNodes+1:i*NumberOfNodes) = d;
    end
    D_state((i-1)*NumberOfNodes+1:i*NumberOfNodes,(i-1)*NumberOfNodes+1:i*NumberOfNodes) = d;
end

%% Optimizer

opts = optimoptions('fmincon','MaxIterations',1e5,'MaxFunctionEvaluations',1e7);
X = fmincon(@(X) Cost(X,T0,NumberOfNodes), X0, [],[],[],[],[],[], @(X) NonLinearContraints(X,T0,D_state,D_control,9.81,NumberOfNodes,X0_P),opts);

% [t,S] = ode45(@(t,S)Game_Dynamics(t,S,U_Traj0,T_nodes,T_end),T_nodes,S0);

%% Unpack the Optimal Solution

N = NumberOfNodes;

xp = X(1:N);
yp = X(N+1:2*N);
zp = X(2*N+1:3*N);
vp = X(3*N+1:4*N);
gammap = X(4*N+1:5*N);
psip = X(5*N+1:6*N);
nxp = X(6*N+1:7*N);
nzp = X(7*N+1:8*N);
mup = X(8*N+1:9*N);

% xe = X(9*N+1:10*N);
% ye = X(10*N+1:11*N);
% ze = X(11*N+1:12*N);
% ve = X(12*N+1:13*N);
% gammae = X(13*N+1:14*N);
% psie = X(14*N+1:15*N);
% nxe = X(15*N+1:16*N);
% nze = X(16*N+1:17*N);
% mue = X(17*N+1:18*N);

%% Plotting Block

figure(1); clf
grid on 
hold on
title('Trajectory')
xlabel('X')
ylabel('Y')
zlabel('Z')
plot3(xp,yp,zp,'r',LineWidth=2)
plot3(xe,ye,ze,'b',LineWidth=2)

figure(2); clf
grid on
hold on
title('nx')
xlabel('Time')
ylabel('nx')
plot(T_nodes,nxp,'r',LineWidth=2)

figure(3); clf
grid on
hold on
title('nz')
xlabel('Time')
ylabel('nz')
plot(T_nodes,nzp,'r',LineWidth=2)

figure(4); clf
grid on
hold on
title('mu')
xlabel('Time')
ylabel('mu')
plot(T_nodes,mup*180/pi,'r',LineWidth=2)

%% 2D Animation with Attack Envelope

% Define the video writer object and set the frame rate
videoFilename = 'constmu2_away.mp4';
v = VideoWriter(videoFilename, 'MPEG-4');
v.FrameRate = 10;  % Set the frame rate (e.g., 30 fps)
open(v);

figure(5); clf;
hold on;
grid on;
xlabel('X');
ylabel('Y');
title('Real Time Plot')

% Initialize plot elements for animation
h1 = plot(xp(1), yp(1), 'bo', 'MarkerSize', 8, 'DisplayName', 'Pursuer');  % Pursuer marker
path1 = plot(xp(1), yp(1), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Pursuer Path');  % Pursuer path

h2 = plot(xe(1), ye(1), 'ro', 'MarkerSize', 8, 'DisplayName', 'Target');  % Evader marker
path2 = plot(xe(1), ye(1), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Target Path');  % Evader path

% Define the attack envelope parameters
half_angle = 15 * pi / 180;  % 15 degrees (half of 30 degrees)
cone_height = 100;  % distance of the attack envelope
cone_slant_length = cone_height / cos(half_angle);  % Slant length of the wedge

% Faster Animation Loop
minLength = min(length(xp), length(xe));  % Ensure equal length for pursuer and evader
hold on;

% Manually set axis limits and frame size
axis([min(min(xp),min(xe)), 1.1*max(max(xp),max(xe)), min(min(yp),min(ye)), 1.1*max(max(yp),max(ye))]); % Manually set axis limits
set(gca, 'XLimMode', 'manual', 'YLimMode', 'manual'); % Prevent axis recalculation
axis equal;  % Maintain aspect ratio
set(gcf, 'Position', [100, 100, 800, 600]); % Set figure size

% Add legend with best position
legend('show', 'Location', 'bestoutside');

for i = 1:minLength   % Plot every 10th point for faster animation
    % Update pursuer and evader positions in the animation
    set(h1, 'XData', xp(i), 'YData', yp(i));  % Update pursuer marker
    set(path1, 'XData', xp(1:i), 'YData', yp(1:i));  % Update pursuer path

    set(h2, 'XData', xe(i), 'YData', ye(i));  % Update evader marker
    set(path2, 'XData', xe(1:i), 'YData', ye(1:i));  % Update evader path

    % Compute the attack envelope 

    % Left boundary of the wedge
    x_leftP = xp(i) + cone_slant_length * cos(psip(i) + half_angle);
    y_leftP = yp(i) + cone_slant_length * sin(psip(i) + half_angle);

    % Right boundary of the wedge
    x_rightP = xp(i) + cone_slant_length * cos(psip(i) - half_angle);
    y_rightP = yp(i) + cone_slant_length * sin(psip(i) - half_angle);

    % Create a shaded region representing the attack envelope
    wedge_shadedP = fill([xp(i), x_leftP, x_rightP], [yp(i), y_leftP, y_rightP], 'b', ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', 'Pursuer Attack Cone');

    % Left boundary of the wedge
    x_leftE = xe(i) + cone_slant_length * cos(psie(i) + half_angle);
    y_leftE = ye(i) + cone_slant_length * sin(psie(i) + half_angle);

    % Right boundary of the wedge
    x_rightE = xe(i) + cone_slant_length * cos(psie(i) - half_angle);
    y_rightE = ye(i) + cone_slant_length * sin(psie(i)- half_angle);

    % Create a shaded region representing the attack envelope
    wedge_shadedE = fill([xe(i), x_leftE, x_rightE], [ye(i), y_leftE, y_rightE], 'r', ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', 'Target Attack Cone');

    % Capture the current frame and write it to video
    frame = getframe(gcf);
    writeVideo(v, frame);

    % Pause for a short time to animate
    pause(1e-6);

    % Remove the previous wedge shading for a smooth animation
    if i < minLength-1
        delete(wedge_shadedP);
        delete(wedge_shadedE);
    end
end

hold off;

% Close the video file
close(v);
disp(['Video saved as ', videoFilename]);


%% Functions

function y = chebyroots(n)
y = zeros(1,n);
for i = 1:n
    y(n+1-i) = cos((2*(i-1)+1)*pi/(2*n));
end
end


function y = dLagrange(x,Xn,i)

N = length(Xn);
Num = 0;

for iter = 1:N

    if iter == i
        continue
    else
        Xnn = zeros(1,N-2);
        skip = 0;
        for it = 1:N
            if it == i || it == iter
                skip = skip + 1;
                continue
            else
                Xnn(it-skip) = Xn(it);
            end
        end
        
        Num = Num + prod(x*ones(N-2,1) - Xnn');
    end
end
without_i = [Xn(1,1:i-1), Xn(1,i+1:end)]';
Den = prod(Xn(i)*ones(N-1,1) - without_i);

y = Num/Den;

end


function C = Cost(X,T,N)

xp = X(1:N);
yp = X(N+1:2*N);
zp = X(2*N+1:3*N);
vp = X(3*N+1:4*N);
gammap = X(4*N+1:5*N);
psip = X(5*N+1:6*N);
nxp = X(6*N+1:7*N);
nzp = X(7*N+1:8*N);
mup = X(8*N+1:9*N);

xe = T(1:N);
ye = T(N+1:2*N);
ze = T(2*N+1:3*N);
ve = T(3*N+1:4*N);
gammae = T(4*N+1:5*N);
psie = T(5*N+1:6*N);
nxe = T(6*N+1:7*N);
nze = T(7*N+1:8*N);
mue = T(8*N+1:9*N);

Xpt = [xp(end);yp(end);zp(end);vp(end);gammap(end);psip(end)];
Xet = [xe(end);ye(end);ze(end);ve(end);gammae(end);psie(end)];
Terminal_error = Xpt - Xet;

% Attack Angle Cost: Penalize Pursuer entering Evader's Attack Envelope
attack_angle_limit = deg2rad(30/2);  % Evader's attack envelope (30 degrees)
Angle_Penalty = 0;

%current seperatio distance
for i = 1:length(xp)
    r = sum((xp(i) - xe(i))^2 + (yp(i) - ye(i))^2 + (zp(i) - ze(i))^2);
    r_danger = 100;
    if r < r_danger
        % Vector from evader to pursuer
        r_pe = [xp(i) - xe(i), yp(i) - ye(i), zp(i) - ze(i)];
        r_pe_norm = r_pe / norm(r_pe);
        
        % Evader's heading direction
        evader_heading = [cos(gammae(i)) * cos(psie(i)), cos(gammae(i)) * sin(psie(i)), sin(gammae(i))];

        % Compute angle between evader heading and relative position vector
        angle_pe = acos(dot(r_pe_norm, evader_heading));

        % Add penalty if pursuer is inside the attack cone (within attack_angle_limit)
        if angle_pe <= attack_angle_limit
            Angle_Penalty = Angle_Penalty + ((attack_angle_limit - angle_pe)^2)/(r/r_danger);
        end
    end
end
    

C = sum((xp-xe).^2 + (yp-ye).^2 + (zp-ze).^2) + Terminal_error'*Terminal_error + Angle_Penalty; 
end


function [c,ceq] = NonLinearContraints(X,T,Ds,Dc,g,N,Initial_State)
c = [];

xp = X(1:N);
yp = X(N+1:2*N);
zp = X(2*N+1:3*N);
vp = X(3*N+1:4*N);
gammap = X(4*N+1:5*N);
psip = X(5*N+1:6*N);

nxp = X(6*N+1:7*N);
mup = X(8*N+1:9*N);
nzp = X(7*N+1:8*N); 
nzpbar = nzp + 1./(cos(mup).*cos(gammap));


% xe = X(9*N+1:10*N);
% ye = X(10*N+1:11*N);
% ze = X(11*N+1:12*N);
% ve = X(12*N+1:13*N);
% gammae = X(13*N+1:14*N);
% psie = X(14*N+1:15*N);
% nxe = X(15*N+1:16*N);
% nze = X(16*N+1:17*N);
% mue = X(17*N+1:18*N);

Y = [xp;yp;zp;vp;gammap;psip]; %xe;ye;ze;ve;gammae;psie];
Y0= [xp(1);yp(1);zp(1);vp(1);gammap(1);psip(1)]; %xe(1);ye(1);ze(1);ve(1);gammae(1);psie(1)];
U = [nxp;nzpbar;mup];

Ydot = Ds*Y;
Udot = Dc*U;

b = zeros(length(Y),1);

b(1:N) = vp.*cos(gammap).*cos(psip);
b(N+1:2*N) = vp.*cos(gammap).*sin(psip);
b(2*N+1:3*N) = vp.*sin(gammap);
b(3*N+1:4*N) = g*(nxp-sin(gammap));
b(4*N+1:5*N) = g*(nzpbar.*cos(mup) - cos(gammap))./vp;
b(5*N+1:6*N) = g*nzpbar.*sin(mup)./(vp.*cos(gammap));

xe = T(1:N);
ye = T(N+1:2*N);
ze = T(2*N+1:3*N);
ve = T(3*N+1:4*N);
gammae = T(4*N+1:5*N);
psie = T(5*N+1:6*N);
nxe = T(6*N+1:7*N);
nze = T(7*N+1:8*N);
mue = T(8*N+1:9*N);

% b(6*N+1:7*N) = ve.*cos(gammae).*cos(psie);
% b(7*N+1:8*N) = ve.*cos(gammae).*sin(psie);
% b(8*N+1:9*N) = ve.*sin(gammae);
% b(9*N+1:10*N) = g*(nxe-sin(gammae));
% b(10*N+1:11*N) = g*(nze.*cos(mue) - cos(gammae))./ve;
% b(11*N+1:12*N) = g*nze.*sin(mue)./(ve.*cos(gammae));

%Angle Constraint    % Attack Angle Cost: Penalize Pursuer entering Evader's Attack Envelope
attack_angle_limit = deg2rad(30/2);  % Evader's attack envelope (30 degrees)
angle_con = zeros(length(xp),1);

% %current seperatio distance
% for i = 1:length(xp)
%     r = sum((xp(i) - xe(i))^2 + (yp(i) - ye(i))^2 + (zp(i) - ze(i))^2);
%     r_danger = 100;
%     if r < r_danger
%         % Vector from evader to pursuer
%         r_pe = [xp(i) - xe(i), yp(i) - ye(i), zp(i) - ze(i)];
%         r_pe_norm = r_pe / norm(r_pe);
%         
%         % Evader's heading direction
%         evader_heading = [cos(gammae(i)) * cos(psie(i)), cos(gammae(i)) * sin(psie(i)), sin(gammae(i))];
% 
%         % Compute angle between evader heading and relative position vector
%         angle_pe = acos(dot(r_pe_norm, evader_heading));
% 
%         if abs(angle_pe) <= attack_angle_limit
%             angle_con(i) = angle_pe;
%         end
%     end
% end
    
% Ue = [zeros(3*N,1)];

c = [nxp - 0.01*ones(1*N,1);nzp - 0*ones(N,1); mup - ones(N,1)*30*pi/180; -nxp - 0.01*ones(1*N,1); -nzp + 0*ones(N,1); -mup - ones(N,1)*30*pi/180];%;abs(Udot(2*N+1:3*N))-(pi/36)*ones(N,1) ];

%c = [nxp - 0.1*ones(1*N,1);nzp - 0*ones(N,1); mup - ones(N,1)*30*pi/180;
%-nxp - 0.1*ones(1*N,1); -nzp + 0*ones(N,1); -mup - ones(N,1)*30*pi/180;abs(Udot(2*N+1:3*N))-(pi/36)*ones(N,1); abs(angle_con - attack_angle_limit*ones(length(angle_con),1))];
ceq = [Ydot - b;Y0-Initial_State; ];

end