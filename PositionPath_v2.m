% INSTRUCTIONS
% 1. Use getParams.m to change parameters
% 2. Run This File
% 3. Open ONR...Inport_Mapper and click from MAT file. Then select
%    Angle_Data. Click check map for readiness
% 4. Simulate in Simulink

% Dylan Jogerst
%% CODE
% clear

function [qA_ts, qB_ts, dqA_ts, dqB_ts, initial_Conditions] = PositionPath_v2(posX, posY, time, Params)
clc
close all

options = optimset('Display','off');

L1 = Params.L1;
L2 = Params.L2;

% CIRCLE PATH TESTING
% xdes = @(t) R*cos(2*t);                                                     % Desired x movement
% ydes = @(t) -0.16 + R*sin(2*t);                                             % Desired y movement
% 
% syms t
% dxdes = diff(xdes(t), t);                                                   % Desired dx movement
% dydes = diff(ydes(t), t);                                                   % Desired dy movement
% 
% dxdes = matlabFunction(dxdes, 'vars', t);                                   % Creates Functions for dx and dy
% dydes = matlabFunction(dydes, 'vars', t);

% sets desired path as well as converts from mm -> m
x_desired = posX/1000;  %xdes(t);                                           % Creates numerical matrices by
y_desired = posY/1000;  %ydes(t);                                           % plugging in time matrix
dx_desired = gradient(x_desired,time);
dy_desired = gradient(y_desired,time);

% qA_guess = input("Input Guess for qA [deg]. Should be Positive: ");         % Initial guesses for each angle
% qB_guess = input("\nInput Guess for qB [deg]. Should be Positive: ");       % at initial position. 
% qC_guess = input("\nInput Guess for qC [deg]. Should be Positive: ");       % (right of circle)
% qD_guess = input("\nInput Guess for qD [deg]. Should be Negative: ");
% dqA_guess = input("Input Guess for dqA [deg/s]. Should be Negative: ");        
% dqB_guess = input("\nInput Guess for dqB [deg/s]. Should be Negative: ");      
% dqC_guess = input("\nInput Guess for dqC [deg/s]. Should be Positive: ");       
% dqD_guess = input("\nInput Guess for dqD [deg/s]. Should be Positive: "); 
% fprintf("\n")

% Input Guesses
qA_guess = -4;%-19;%23;  
qB_guess = 225;%224;%190; 
qC_guess = 90;%74;%106; 
qD_guess = -92;%-75;%-115;
dqA_guess = -5;  
dqB_guess = -5; 
dqC_guess = 5; 
dqD_guess = 5;

qA_guess = qA_guess * pi/180;                                               % Converts degrees to radians
qB_guess = qB_guess * pi/180;
qC_guess = qC_guess * pi/180;
qD_guess = qD_guess * pi/180;
dqA_guess = dqA_guess * pi/180;
dqB_guess = dqB_guess * pi/180;
dqC_guess = dqC_guess * pi/180;
dqD_guess = dqD_guess * pi/180;


q0 = [qA_guess; qB_guess; qC_guess; qD_guess];                              % Puts guesses into matrix
dq0 = [dqA_guess; dqB_guess; dqC_guess; dqD_guess];

q_results = [0, 0, 0, 0];                                                   % initializes results
dq_results = [0, 0, 0, 0];                                                  % prob not-the-best-way™ to do this

for iter=1:numel(time) 

% qA = q(1); qB = q(2); qC = q(3); qD = q(4); 

F = @(q) [L1*cos(q(1)) + L2*cos(q(1)+q(4)) - x_desired(iter);               % Solves for qA, qB, qC, qD
          L1*cos(q(2)) + L2*cos(q(2)+q(3)) - x_desired(iter);
          L1*sin(q(1)) + L2*sin(q(1)+q(4)) - y_desired(iter);
          L1*sin(q(2)) + L2*sin(q(2)+q(3)) - y_desired(iter)];

temp = fsolve(F, q0, options);                                                       % Solves system

% qA = temp(1); qB = temp(2); qC = temp(3); qD = temp(4); 
% dqA = d(1); dqB = d(2); dqC = d(3); dqD = d(4);
dF = @(d) [-L1*sin(temp(1))*d(1) - L2*sin(temp(1)+temp(4))*(d(1)+d(4)) - dx_desired(iter);
           -L1*sin(temp(2))*d(2) - L2*sin(temp(2)+temp(3))*(d(2)+d(3)) - dx_desired(iter);
            L1*cos(temp(1))*d(1) + L2*cos(temp(1)+temp(4))*(d(1)+d(4)) - dy_desired(iter);
            L1*cos(temp(2))*d(2) + L2*cos(temp(2)+temp(3))*(d(2)+d(3)) - dy_desired(iter);];

dtemp = fsolve(dF, dq0, options);

q0 = temp;                                                                  % Assigns the answers as 
dq0 = dtemp;                                                                % the next guess values. 

    if q_results == [0, 0, 0, 0]
        q_results = temp';                                                  % Continuation of not-the-best-way™
    else 
        q_results = cat(1, q_results, temp');
    end

    if dq_results == [0, 0, 0, 0]
        dq_results = dtemp';                                               
    else 
        dq_results = cat(1, dq_results, dtemp');
    end

end

q_results_deg = q_results * (180/pi);                                       % Degree version for Troubleshooting
dq_results_deg = dq_results * (180/pi);

% Time Series for exporting to Simulink
% ts = timeseries(datavals,timevals,'Name',tsname)

qA_ts = timeseries(q_results(:,1),time,'Name','qA');
qB_ts = timeseries(q_results(:,2),time,'Name','qB');
qC_ts = timeseries(q_results(:,3),time,'Name','qC');
qD_ts = timeseries(q_results(:,4),time,'Name','qD');
dqA_ts = timeseries(dq_results(:,1),time,'Name','dqA');
dqB_ts = timeseries(dq_results(:,2),time,'Name','dqB');
dqC_ts = timeseries(dq_results(:,3),time,'Name','dqC');
dqD_ts = timeseries(dq_results(:,4),time,'Name','dqD');

% Initial conditions
initial_Conditions = [qC_ts(1), qD_ts(1)];


% Saves time and angles to file to export to simulink
save('ONR_Single_Leg_Angle_Data.mat',"qA_ts", "qB_ts", "qC_ts", "qD_ts", "dqA_ts", "dqB_ts", "dqC_ts", "dqD_ts"); 

fprintf("Done\n");



