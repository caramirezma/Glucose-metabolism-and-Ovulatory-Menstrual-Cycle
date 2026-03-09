%-------------------------------------------
% Coupling Model 
% Insulin-Glucose metabolism, Beta dynamic proposed & dynamic Estradiol coupling
%Date: 31/01/2024 (Creation)
%09/03/2026(Last Modification)
%-------------------------------------------
%Space of states Description

function [dx]=baseline_Topp_E2P4_Roblitzinput(t,x,input)

Beta=x(1);
Ins=x(2);
G=x(3);
SI=x(4);

%% Interpolation of the inputs with the ODE time
Ue_F=input.E2_Fisch;
Up_F=input.P4_Fisch;
t_F=input.Time_Fisch;
ii=find(t<t_F);
isempty(ii);
if isempty(ii)==1
Ue=Ue_F(end);
Up=Up_F(end);
else
 ii=ii(1);
 i=ii-1;

 m_e=(Ue_F(ii)-Ue_F(i))/(t_F(ii)-t_F(i));
 m_p=(Up_F(ii)-Up_F(i))/(t_F(ii)-t_F(i));

if abs(t-t_F(i))<abs(t-t_F(ii))
    Ue=m_e*(t-t_F(i))+Ue_F(i);
    Up=m_p*(t-t_F(i))+Up_F(i);
else
    Ue=m_e*(t-t_F(ii))+Ue_F(ii);
    Up=m_p*(t-t_F(ii))+Up_F(ii);
end
end

if Up==0
    Up=0.2;
end


%% Coupling with GI dynamics
%Coefficients for Monod-Hill equations for G and Ins balance, depending on Estradiol

%% Parameters & Differential equations
par.R_0= 890; %FAST-864 NonFast-890 1200 1000 1200 864 IFAC1150 970 570 864;        %[mg/dL.d]   %Net rate of production at zero glucose Topp
par.E_G0=8; %FAST-10 NONFAST-8 12 9 ifac 8.7 9 *58/(58+Ue)*(Up/(0.5+Up));   %8 7   1.44[1.d]       %Insulin independent glucose disposal rate-Total glucose effectiveness at "zero insulin" Taken from Topp
par.k=432;%432;       %[1/d]       %Insulin clearance rate. Taken from Topp
%% =============Insulin sensitivity and ISR dynamics========================
par.kg=1; %Hill coefficient-it was available for trials
Ks_E2=62; %[pg/mL] Inverse of the affinity constant for Insulin sensitivity related to estradiol levels
Ks_P4=2; % [ng/mL] [pg/mL] Inverse of the affinity constant for Insulin sensitivity related to progesterone levels

par.k_I_sec=10; %[µU/mL.d.mg] maximum rate of Insulin secretion/mg
cons.Ks_I_G_sec=100;  %[mg/dL] Inverse of the affinity constant for Insulin secretion related to glucose levels
Ke_sec=33; %[pg/mL] Inverse of the affinity constant for Insulin secretion related to estradiol levels;

k_P4_sec=0.004;

%% G, E2 and P4 contributions to I secretion
 Ins_sec=par.k_I_sec.*(G^par.kg)/(cons.Ks_I_G_sec^par.kg+G^par.kg)*Ue/((Ke_sec+Ue))*(1+k_P4_sec*(Up)); %[µU/mg.d]
%% =============Beta dynamics========================
%From literature:
%apoptosis rate 5% Apoptosis in pancreatic β-islet cells in Type 2 diabetes Tatsuo Tomita
%In the human pancreas, β-cell mass has been reported to vary from 0.6 to 2.1 g, and the 
%amount of insulin in the gland has been observed to range from 50 to 250 ug/g 
%The  frequency  of  β-cell  replication  was  very  low  at  0.04-0.06%
%of  β-cell  mass (Marchetti and Ferrannini,2015)
k_beta=0.00045;  %Maximum rate of beta cell growth
K_beta_G_Apop=125; % [mg/dL] Inverse affinity constant with G for Beta-cell death: G concentration triggering apoptosis 
K_beta_G_g=70; % [mg/dL] Inverse affinity constant with G protecting Beta-cell mass: G concentration protecting the cell mass

K_beta_E2=50; % [mg/dL] Inverse affinity constant with E2 protecting Beta-cell mass: E2 concentration protecting the cell mass

mu_beta_growth=k_beta*(Ue/(K_beta_E2+Ue))*G/(K_beta_G_g+G);

%% Replication  and  apoptosis  rate  should  be  about  the  same  to  maintain  the  β-cell  mass  at  a  delicate  balance
%http://dx.doi.org/10.17305/bjbms.2016.919-Tatsuo Tomita*
%mu_Beta_Apop=0.0146; %0.0086 0.00833 0.013 0.016 0.0013 0.005 0.1 1.6; 

k_beta_Apop=0.00037;  %Maximum rate of beta cell growth
mu_Beta_Apop=k_beta_Apop*G/(K_beta_G_Apop+G); %k en el articulo es 0.0004, esta ajusta mejor long term

%% Insulin dependent glucose uptake S_I,as a function of Estradiol and Progesterone

par.k_I_up=12; % 6.5 9 4.5IFAC 6 4 16 2e2[mL/pg.d] very sensitive with 2 monod 1.1e+2 shape maximum rate of Insulin reception matching with S_I in literature (for glucose uptake)
cons.Ks_I_up=70; % 6.5 4 15 with kgrowth 0.03 and iup 1.6
%% two Monods
alpha_e=1;% Hill coefficient available for trials
alpha_p=1;% Hill coefficient available for trials

Prom=Ue^alpha_e/(Ks_E2^alpha_e+Ue^alpha_e);
Inhib=Ks_P4^alpha_p/(Ks_P4^alpha_p+Up^alpha_p); 
Ins_up=SI*Ins;

%% ODE system
dBeta=(Beta*mu_beta_growth-Beta*mu_Beta_Apop);
dG=par.R_0-((par.E_G0+(Ins_up))*G);
dIns=(Beta*Ins_sec)-(par.k*Ins);%-250*Ue/(Ue+150)*Ins; %-

%% E2 and P4 in SI
dSI=SI-(par.k_I_up*(Prom*Inhib)*1/(cons.Ks_I_up+Ins));

dx=[dBeta;dIns;dG;dSI];
end