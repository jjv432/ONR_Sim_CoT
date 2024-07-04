clc
clear all
close all
format compact

%%

Params = getParams; %only need to call once per trap_trajectory optimization

percent_tolerance = 0.05;
iteration_count = 6;
j = 1;
tolerance_bool = 1;

CoT = zeros(1,iteration_count);
pecent_Change = zeros(1,iteration_count);

% Is params the new thing? or is it the q guesses? or both?
while ((j<=iteration_count) && tolerance_bool)

    [posX, posY, time] = trap_trajectory_v2(Params);

    [qA_ts, qB_ts, dqA_ts, dqB_ts, initial_Conditions] = PositionPath_v2(posX, posY, time, Params);

    Cost = fake_CoT_fn(qA_ts, qB_ts, dqA_ts, dqB_ts, initial_Conditions); %Resetting params based on optimization

    [New_Params] = fake_Optimizer(Cost, Params);

    Params = New_Params;

    CoT(j) = Cost;

    if j ~= 1
        percent_Change(j) = (CoT(j) - CoT(j-1)) / CoT(j);
    end

    if j>3
        if percent_Change(j) < percent_tolerance
            if percent_Change(j-1) < percent_tolerance
                if percent_Change(j-2) < percent_tolerance
                    if percent_Change(j-3) < percent_tolerance
                        tolerance_bool = 0;
                    end
                end
            end
        end
    end

    j = j+1;

    clearvars -except Params iteration_count percent_tolerance j CoT tolerance_bool percent_Change
end

if ~tolerance_bool
    fprintf("Solution Converged Due To Tolerance\n")
else
    fprintf("Solution Converged Due To Iteration\n")
end

figure()
    plot(1:length(CoT), CoT)
    xlabel("Iteration")
    ylabel("CoT")
    title("Optimized CoT")
    grid on
