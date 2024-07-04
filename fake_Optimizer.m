function [Optimized_Params] = fake_Optimizer(Cost, old_Params)

L1 = old_Params.L1;
L2 = old_Params.L2;
N = old_Params.N;
T = old_Params.T;
C = old_Params.C;
D = old_Params.D;
L = old_Params.L;
beta = old_Params.beta;
h1 = old_Params.h1;
h2 = old_Params.h2;


Optimized_Params.L1 = L1 * 1;
Optimized_Params.L2 = L2* 1;
Optimized_Params.N = N* 1;
Optimized_Params.T= T* 1;
Optimized_Params.C = C* 1;
Optimized_Params.D = D* 1;
Optimized_Params.L = L* 1;
Optimized_Params.beta= beta* 1;
Optimized_Params.h1 = h1* 1;
Optimized_Params.h2 = h2* 1;


end