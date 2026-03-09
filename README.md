The Main function Solving the ODE system is SOLVER_GynCycle_inputs.m
It starts with the initial conditions for either non Fasting (Daily median Glucose) or fasting scenario for Beta, Insulin, Glucose and S_I.
The fasting/non fasting setting must be in agreement with the parameters used in the ODE: coupling_Glucose_E2P4_GynCycleinput.m.

If using the initial conditions for the Non-Fasting scenario in SOLVER_GynCycle_inputs.m, set inside coupling_Glucose_E2P4_GynCycleinput:
lines 50 and 51
par.R_0= 890;
par.E_G0=8;

If using the initial conditions for the Fasting scenario in SOLVER_GynCycle_inputs.m, set inside coupling_Glucose_E2P4_GynCycleinput:
lines 50 and 51
par.R_0= 864;
par.E_G0=10;

You need to have in the same folder the main function SOLVER_GynCycle_inputs.m, the ODE system coupling_Glucose_E2P4_GynCycleinput, and the input profile file E2P4resultsBase.mat

Runing the solver with the inputs from the GynCycle gives:
Figure 2: The glucose profile along one menstrual cycle compoared to the experiments from CGM data, which corresponds to the right side of Figure 13. in the paper
Figure 3: The glucose profile during 300 days presented in the upper right of Figure 14. in the paper
Figure 4: An insulin profile
Figure 5: The Beta-cell mass profile presented in the lower row of Figure 14. in the paper
Figure 6: The S_I (insulin isensitivity) profile
Figures 1 and 7 are the input profiles before and after the ODE solution, to maker sure they are remain the same along the process, since there is an interpolation inside the ODE to adjust the times from the input profiles and the ones of the ODE solver.

*Please always cite if using this code
