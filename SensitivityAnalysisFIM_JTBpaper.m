clear all
clc
close all

tic
% Parameters
%Parameters =============
R_0= 890; %890Non Fasting 864Fasting 1200 1000 1200 864 IFAC1150 970 570 864;        %[mg/dL.d]   %Net rate of production at zero glucose Topp
E_G0=8; %8Non fasting 10Fasting 12 9 ifac 8.7 9 *58/(58+Ue)*(Up/(0.5+Up));   %8 7   1.44[1.d]       %Insulin independent glucose disposal rate-Total glucose effectiveness at "zero insulin" Taken from Topp
k_cl=432;%432;       %[1/d]       %Insulin clearance rate. Taken from Topp
K_G_sec=100;  %100 110 220 120 90 [mg/dL] Affinity constant for Insulin secretion
Ks_E2=62; %50 10 60 2 higher Si but qualitatively weird during ovulation
Ks_P4=2; % 0.5 ifac 400 1.7
K_E2_sec=33; %poster IFAC 48;
k_beta=0.00045;   %0.0355 0.0343 0.0335 IFAC =0.03069 0.00033 0.00046 0.0003 0.00013 %mgmL/pg.d maximum growth rate with apop 0.5% and Ks 1500
K_beta_G_Apop=125;%150 ifac
K_beta_G_g=70;%70
K_beta_E2=50;
k_beta_Apop=0.0004;
Ks_up=70; % 6.5 4 15 with kgrowth 0.03 and iup 1.6


k_I_sec_est=10; %10 11        %pathologic steady state 0.335; %%[µU/mL.d.mg] maximum rate of Insulin secretion/mg
k_I_up_est=12; % 6.5 9 4.5IFAC 6 4 16 2e2[mL/pg.d] very sensitive with 2 monod 1.1e+2 shape maximum rate of Insulin reception matching with S_I in literature (for glucose uptake)
k_P4_sec_est=0.3/(16.7^1.5); %0.0044





%% Define baseline parameters





% Run simulations for sampled k_prost values
% Run baseline simulation

k_P4_sec=k_P4_sec_est;
k_I_sec=k_I_sec_est;
k_I_up=k_I_up_est;
%k_I_sec = 10;
sim('Sim_Metabolico_Param.slx'); 

max_Gest= max(Gout);
      GestP4=Gout;

    k_P4_sec = k_P4_sec*(1-10^-6); %perturbation
  % k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
    max_Gout_pert = max(Gout); % Store max P
       G_pert_kP4_P4=Gout;

  %mi_k_P4=(max_Gest-max_Gout_pert)/(k_P4_sec_est-k_P4_sec);
mi_k_P4=(GestP4-G_pert_kP4_P4)./(k_P4_sec_est-k_P4_sec);


% Run simulations for sampled k_I_sec values

    k_P4_sec=k_P4_sec_est;
    k_I_sec = k_I_sec*(1-10^-6);
  % k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
    max_Gout_pert = max(Gout); % Store max P
       G_pert_kIsec_P4=Gout;
  %mi_k_Isec=(max_Gest-max_Gout_pert)/(k_I_sec_est-k_I_sec);

mi_k_Isec=(GestP4-G_pert_kIsec_P4)./(k_I_sec_est-k_I_sec);

% Run simulations for sampled k_I_sec values
    
    k_I_sec=k_I_sec_est;
    k_I_up = k_I_up*(1-10^-6);
  % k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
    max_Gout_pert = max(Gout); % Store max P
         G_pert_kIup_P4=Gout;
  %mi_k_Iup=(max_Gest-max_Gout_pert)/(k_I_up_est-k_I_up);
mi_k_Iup=(GestP4-G_pert_kIup_P4)./(k_I_up_est-k_I_up);



m_FIMP4=[mi_k_Iup mi_k_Isec mi_k_P4];
FIMP4=m_FIMP4'*m_FIMP4;
RP4=rank(FIMP4);
CMatrixP4=inv(FIMP4); %Covariance Matrix

for i=1:size(CMatrixP4)
    for j=1:size(CMatrixP4)
     if i==j
      CorrMatrixP4(i,j)=1;
     else
      CorrMatrixP4(i,j)=CMatrixP4(i,j)/sqrt(CMatrixP4(i,i)*CMatrixP4(j,j));
    end
    end
end

RP42=rank(CorrMatrixP4);
% Run simulations for sampled k_prost values
% Run baseline simulation


k_I_sec=k_I_sec_est;
k_I_up=k_I_up_est;
%k_I_sec = 10;
sim('Sim_Metabolico_ParamE2.slx'); 

max_Gest= max(Gout);
      Gest=Gout;

   
% Run simulations for sampled k_I_sec values

    
    k_I_sec = k_I_sec*(1-10^-6);
  % k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_ParamE2.slx'); 
 
    max_Gout_pert = max(Gout); % Store max P
        G_pert_kIsec_E2=Gout;
  %mi_k_Isec=(max_Gest-max_Gout_pert)/(k_I_sec_est-k_I_sec);
mi_k_Isec=(Gest-G_pert_kIsec_E2)/(k_I_sec_est-k_I_sec);

% Run simulations for sampled k_I_up values
    
    k_I_sec=k_I_sec_est;
    k_I_up = k_I_up*(1-10^-6);
  % k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_ParamE2.slx'); 
 
    max_Gout_pert = max(Gout); % Store max P
    G_pert_kIup_E2=Gout;
  mi_k_Iup=(Gest-G_pert_kIup_E2)/(k_I_up_est-k_I_up);

m_FIME2=[mi_k_Iup mi_k_Isec];
FIME2=m_FIME2'*m_FIME2;
RE2=rank(FIME2);
CMatrixE2=inv(FIME2); %Covariance

for i=1:size(CMatrixE2)
    for j=1:size(CMatrixE2)
     if i==j
      CorrMatrixE2(i,j)=1;
     else
      CorrMatrixE2(i,j)=CMatrixE2(i,j)/sqrt(CMatrixE2(i,i)*CMatrixE2(j,j));
    end
    end
end
RE2_2=rank(CorrMatrixE2);

figure(1)
hold on
plot(tiempo,G_pert_kIup_P4)
plot(tiempo,G_pert_kIup_E2)
plot(tiempo,G_pert_kIsec_P4)
plot(tiempo,G_pert_kIsec_E2)
plot(tiempo,G_pert_kP4_P4)
xlabel('days')
ylabel('G mg/dL')
legend('G_pert_kIup_P4','G_pert_kIup_E2','G_pert_kIsec_P4', 'G_pert_kIsec_E2','G_pert_kP4_P4')
