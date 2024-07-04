function [Cost, Params] = fake_CoT_fn(qA_ts, qB_ts, dqA_ts, dqB_ts, initial_Conditions)

Params.L1 = randi(100);
Params.L2 = randi(100);
Params.N = randi(100);
Params.T = randi(100);
Params.C = randi(100);
Params.D = randi(100);
Params.L = randi(100);
Params.beta = randi(100);
Params.h1 = randi(100);
Params.h2 = randi(100);

Cost = randi(100);

end