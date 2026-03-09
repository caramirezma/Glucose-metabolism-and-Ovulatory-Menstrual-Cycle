The Main function Solving the ODE system is SOLVER_Roblitz_Inputs.m
It starts with the initial conditions for either non Fasting (Daily median Glucose) or fasting scenario
The fasting/non fasting setting must be in agreement with the parameters used in the ODE: baseline_Topp_E2P4_Roblitzinput.m

If using the initial conditions for the Non-Fasting scenario in SOLVER_Roblitz_Inputs.m, set inside baseline_Topp_E2P4_Roblitzinput.m:
lines 50 and 51
par.R_0= 890;
par.E_G0=8;

If using the initial conditions for the Fasting scenario in SOLVER_Roblitz_Inputs.m, set inside baseline_Topp_E2P4_Roblitzinput.m:
lines 50 and 51
par.R_0= 864;
par.E_G0=10;

Runing the solver with the inputs from the GynCycle gives:
Figure 2: The glucose profile along one menstrual cycle compoared to the experiments from CGM data, which corresponds to the right side of Figure 13. in the paper
Figure 3: The glucose profile during 300 days presented in the upper right of Figure 14. in the paper
Figure 4: An insulin profile
Figure 5: The Beta-cell mass profile presented in the lower row of Figure 14. in the paper
Figure 6: The S_I (insulin isensitivity) profile
Figures 1 and 7 are the input profiles before and after the ODE solution, to maker sure they are remain the same along the process, since there is an interpolation inside the ODE to adjust the times from the input profiles and the ones of the ODE solver.
