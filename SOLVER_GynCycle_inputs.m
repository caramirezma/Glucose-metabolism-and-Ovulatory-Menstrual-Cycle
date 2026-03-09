clear all
close all
clc
format long
%% Initial conditions for physiological function
%dx=[dBeta;dIns;dG;dx1dt;dx2dt;dx3dt;dSB_dt;dLdt;dPrior;dPrimar;dPrAnF;dSmAnF;dReF;dGrF;dDomF;dOv;dLut_1;dLut_2;dLut_3;dLut_4;dRP_LH;dLH;dRP_FSH;dFSH; Ue; Up; SI; InhA];
%% Non Fasting
x0=[850, 5.6, 107,1];

%% Fasting: When using Fasting change Ro and Ego in the model
%x0=[850, 4.9, 84,10];

%850 5.6 107 Non fasting %20 Dec 2025
%850 4.9 84 fasting

%% ODE for baseline-physiology
t0=0:0.001:300;

%% 26

M= [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 0];
% M = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

Atol=zeros(size(M));
 
%% Roblitz 
  options=odeset('Mass',M,'AbsTol',0.001,'RelTol',0.001); %-8 poster
 

%% Fischer and Roblitz inputs

load E2P4resultsBase.mat
input.E2_Fisch=E2.Y;
input.P4_Fisch=P4.Y;
input.Time_Fisch=E2.Time;
Ue=E2.Y;
Up=P4.Y;
timeF=E2.Time;

%Plotting the inputs

figure(1)
yyaxis left
plot(timeF, Ue, 'k','LineWidth',2); hold on;
ylabel('E2 [pg/mL]','FontSize',22)
yyaxis right
plot(timeF, Up, 'k','LineWidth',2); hold on;
hold on;
grid on;
xlabel('Time [days]','FontSize',22)
ylabel('P4 [ng/mL]','FontSize',22)
set(gca,'FontSize',20)

  tic
  [t,y] =ode15s(@(t,y) coupling_Glucose_E2P4_GynCycleinput(t,y,input),t0,x0,options);  
toc


%% Plotting
torig=t;
y=y';
%% Outputs Topp-Fitted E2 and P4
Beta=y(1,:); %mg     %y.y(1,:);
Insp=y(2,:);  %µU/mL  %y.y(2,:)*6;    %converting µU/mL to pM https://doi.org/10.2337/dc10-0034.Insulin Assay Standardization: Leading to Measures of Insulin Sensitivity and Secretion for Practical Clinical Care: Response to Staten et al.
G=y(3,:);    %mg/dL        %y.y(3,:)*0.0555; %converting mg/dL to mM (mmol/L) in glucose https://www.ncbi.nlm.nih.gov/books/NBK348987/
Insc=zeros(size(Insp)); %Clamp studies deactivated
SI=y(4,:); 




% err=zeros(size(Biocyclemeasurements(:,1)));
% for i=1:size(err)
% err(i)=1.1;
% end


tCGM_menses=[0:0.5:7.5];
tCGM_LF=[7.5:0.5:16];
G_LF=5.8; %Reported in table 1, from Lin et al. https://doi.org/10.1038/s41746-023-00884-x
tCGM_Ov=[16:1:21];
G_Ov=5.9; %Reported in table 1, from Lin et al. https://doi.org/10.1038/s41746-023-00884-x
tCGM_Lu=[21:1:30];
G_Lu=6.1; %Reported in table 1, from Lin et al. https://doi.org/10.1038/s41746-023-00884-x
tCGM_menses2=[30:1:37.5];
G_menses=6; %Reported in table 1, from Lin et al. https://doi.org/10.1038/s41746-023-00884-x

figure(2)
hold on
plot(t,G,'LineWidth',2);
hold on
 
%% Exp CGMs https://www.nature.com/articles/s41746-023-00884-x
scatter(tCGM_LF,G_LF/0.0555)
scatter(tCGM_menses,G_menses/0.0555)
scatter(tCGM_Ov,G_Ov/0.0555)
scatter(tCGM_Lu,G_Lu/0.0555)
scatter(tCGM_menses2,G_menses/0.0555)
grid on;
xlabel('Time [days]','FontSize',30)
xlim([0, 30])
ylim([92, 123])
ylabel('G[mg/dL]','FontSize',30) %mili mol/L Alternative units [mg/dL]
legend('Model','E2[pg/mL]','P4[ng/mL]','Exp.G[mg/dL]')
set(gca,'FontSize',15)

figure(3)
hold on
plot(t,G,'LineWidth',2);
hold on
 
%% Exp CGMs
grid on;
xlabel('Time [days]','FontSize',30)
ylabel('G[mg/dL]','FontSize',30) %mili mol/L Alternative units [mg/dL]
legend('Model','E2[pg/mL]','P4[ng/mL]')
set(gca,'FontSize',15)

figure(4)
plot(t,Insp,'LineWidth',2);
grid on;
xlabel('Time [days]','FontSize',30)
ylabel('Insulin pancreas[µU/mL]','FontSize',30) % pico mol/L Alternative units [µU/mL]
set(gca,'FontSize',15)

figure(5)
plot(t,Beta,'LineWidth',2);
hold on;
%(timeF,Up,'LineWidth',2);
%plot(timeF,Ue,'LineWidth',2);
grid on;
xlabel('Time [days]','FontSize',30)
ylabel('Beta mass [mg]','FontSize',30)%'Glucose [mg/dL]','FontSize',30)
ylim([820,860])
legend('B-cell mass','E_2','P_4')
set(gca,'FontSize',15)


figure(6)
grid on
plot(t,(SI/24/60),'LineWidth',2); %SI has 1/µU.days units=literature reports it in 1/µU.min
hold on;
xlabel('Time [days]','FontSize',30)
ylabel('SI(E_2,P_4) [mL.min^1.µU^1]','FontSize',30) %mili mol/L Alternative units [mg/dL]
legend('Model')
set(gca,'FontSize',15)

figure(7)
%Inputs after the interpolation inside the ODE, to make sure they are right

hold on
yyaxis left; plot(E2.Time,E2.Y); hold on;
hold on
yyaxis right; plot(P4.Time, P4.Y)
