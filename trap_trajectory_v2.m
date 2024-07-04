% clc
% clear
% close all
% Written by Jonathan Boylan
% Edited by Dylan Jogerst
% Edited again by Jack Vranicar (6/24/24)
%%

function [posX, posY, time] = trap_trajectory_v2(Params)

N = Params.N;
T = Params.T;
C = Params.C;
D = Params.D;
L = Params.L;
beta = Params.beta;
h1 = Params.h1;
h2 = Params.h2;


getParams

% Origin point (midpoint on ground)
origin = [0; -220]; %-220 %-170

% Creates points of trapezoid
ptA = origin + [L/2; 0];
ptB = ptA + [h1*cos(beta); h1*sin(beta)];
ptC = origin + [0; h2];
ptD = origin + [-L/2; 0];

% Trapezoid
trap = [ptA, ptD, ptC, ptB, ptA];

% Calculate stance and flight times
stance_coeff = D/100;
flight_coeff = 1 - stance_coeff;
Tstance = T * stance_coeff;
Tflight = T - Tstance;

% Lengths of Trapezoid for point distrubution
AB = h1/(sin(beta));
BC = sqrt(((L/2)+(h1/(tan(beta))))^2 + (h2-h1)^2);
CD = sqrt((L/2)^2 + (h2)^2);
dist_total = AB + BC + CD;
AB_prop = AB/dist_total;
BC_prop = BC/dist_total;
CD_prop = CD/dist_total;

% Time intervals for stance and flight phases
t1 = [0, Tstance];% Stance phase (points A to D)

% t2 = linspace(0, Tflight, 4);% Flight phase (points D to C to B to A)
% LIMITATION: Equal time between flight points.

t2 = [0, CD_prop*Tflight, (BC_prop+CD_prop)*Tflight, Tflight];
% LIMITATION: time between ref points are proportional off lengths

% Generate a form-fitting spline through the points
stance_cycleX = linspace(ptA(1), ptD(1), N*stance_coeff);
stance_cycleY = linspace(ptA(2), ptD(2), N*stance_coeff);
flight_cycleX = pchip(t2, [ptD(1),ptC(1),ptB(1),ptA(1)], linspace(0,Tflight,N*flight_coeff));
flight_cycleY = pchip(t2, [ptD(2),ptC(2),ptB(2),ptA(2)], linspace(0,Tflight,N*flight_coeff));

% Append the splines into single trajectory
cycleX = cat(2, stance_cycleX, flight_cycleX);
cycleY = cat(2, stance_cycleY, flight_cycleY);

% BOOM ARM TEMP
% cycleX = -latestFootSpace(:,1)';
% cycleY = latestFootSpace(:,2)'; 

% Time for 1 cycle to use for path
cycle_time = linspace(0, T, N);

% Total simulation time with C cycles
time = linspace(0,C*T,C*N);

% Vectors of points to use in simulation
posX = cycleX;
posY = cycleY;

% Accounts for cycles and repeats path data if needed
if (C>1)

    for iter=1:(C-1)

    posX = cat(2, posX, cycleX);
    posY = cat(2, posY, cycleY);

    end

end

trajectory = [posX; posY];
end