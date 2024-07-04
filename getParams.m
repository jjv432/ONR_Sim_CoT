function [Params] = getParams()

% LENGTH
L1 =  0.10; % m                                                            % Short Arm Length 
L2 =  0.20; % m                                                            % Long Arm Length 
%R = 0.05;                                                                  % Radius of Circle Path (m)
% Boom: L1 = 0.070 L2 = 0.155
% ONR:  L1 = 0.065 L2 = 0.200
% Mino: L1 = 0.100 L2 = 0.200

% TIME
%Tend = 3.14*2;                                                              % Length of Simulation
%Ts = 0.01;                                                                  % Time Increment

% GATE PATH
N = 100;                                                                    % resolution
T = 1/4.75; % s                                                                % stride duration
C = 5;                                                                      % stride cycles
D = 50; %                                                                   % duty cycle 
L = 160; % mm                                                               % Stride length (Variable)
beta = deg2rad(60); % rad                                                   % Approach angle (Variable)
h1 = 46.19; % mm                                                               % Step height 1 (Fixed)
h2 = 80; % mm                                                               % Step height 2 (Fixed)
% Boom:
% ONR:
% Mino: T = 1/4.75 s
%       D = 50 %
%       L = 160 mm
%       beta = 60 deg
%       h1 = 46.19 mm
%       h2 = 100 mm (???)
%       Kp = 1.70
%       Kd = 0.018
Params.L1 = L1;
Params.L2 = L2;
Params.N = N;
Params.T = T;
Params.C = C;
Params.D = D;
Params.L = L;
Params.beta = beta;
Params.h1 = h1;
Params.h2 = h2;
end