%This code provides the response of G, I, B, with a variation on the
%parameter k_I_sec
% 
% clear all
clc
close all

tic
%% Parameters =============
R_0= 890; %890Non Fasting 864Fasting %[mg/dL.d]   %Net rate of production at zero glucose Topp
E_G0=8; %8Non fasting 10Fasting;   [1.d]       %Insulin independent glucose disposal rate-Total glucose effectiveness at "zero insulin" Taken from Topp
k_cl=432;%432;       %[1/d]       %Insulin clearance rate. Taken from Topp
K_G_sec=100;  % [mg/dL] Affinity constant for Insulin secretion
Ks_E2=62; %
Ks_P4=2; % 
K_E2_sec=33; %
k_beta=0.00045;   %mgmL/pg.d maximum growth rate with apop 
K_beta_G_Apop=125;%
K_beta_G_g=70;%
K_beta_E2=50;
k_beta_Apop=0.0004;
Ks_up=70; % 
k_I_sec_est=10;  %%[µU/mL.d.mg] maximum rate of Insulin secretion/mg
k_I_up=12; % 6.5 9 4.5IFAC 6 4 16 2e2[mL/pg.d] very sensitive with 2 monod 1.1e+2 shape maximum rate of Insulin reception matching with S_I in literature (for glucose uptake)
k_P4_sec=0.3/(16.7^1.5); %0.0044

% Run baseline simulation

k_I_sec=k_I_sec_est;
%k_I_sec = 10;
sim('Sim_Metabolico_Param.slx'); 

max_Gest= max(Gout);
      Gest=Gout;



%% Define baseline parameters

%baseline_params = struct('k_I_up', 2);  % Baseline PGE2 value
%baseline_params = struct('k_P4_sec', 0.0002);  % Baseline PGE2 value
baseline_params = struct('k_I_sec', 10);  % Baseline PGE2 value


par_min = 8;  % 1-0.2% % 1
par_max = 12; % 1+0.2  40


num_samples = 40;  % Number of samples

% Generate uniformly distributed k_prost samples
%parameter_samples.k_I_up = round(unifrnd(par_min, par_max, [num_samples, 1]), 4);
parameter_samples.k_I_sec = round(unifrnd(par_min, par_max, [num_samples, 1]), 4);

% Initialize arrays for max values
max_Gout = zeros(num_samples,1);
max_Bout = zeros(num_samples,1);
max_Iout = zeros(num_samples,1);

% Initialize figure with 2x2 subplots
figure(1);
tiledlayout(1,2);

%% -------------------- Top Left: Glucose --------------------%%
nexttile;
hold on; grid on;
xlabel('Time');
ylabel('Glucose');
title('Sensitivity Analysis: Glucose');

% Run simulations for sampled k_prost values
for i = 1:num_samples
    %k_I_up = parameter_samples. k_I_up(i);
   k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
    max_Gout(i) = max(Gout); % Store max G

     %if k_I_up < 12
    if k_I_sec < 10
    
    plot(tiempo,Gout,'Color', [0.49, 0.18, 0.56]); % Lower than baseline in purple
    else
        plot(tiempo,Gout,'Color', [0.26, 0.62, 0.32]); % Normal or above baseline in black
    end

mi(i)=(max_Gest-max_Gout(i))/(k_I_sec_est-k_I_sec);

if k_I_sec == 10
    ibaseline=i;
end

end

% Run baseline simulation
%k_I_up=12;
k_I_sec = 10;
sim('Sim_Metabolico_Param.slx'); 
 plot(tiempo,Gout, 'r', 'LineWidth', 2); % Baseline in red
 % hold off;


%% -------------------- Bottom Left: Correlation (Max Blood Volume vs. k_prost) --------------------
nexttile;
hold on;
% below_baseline = parameter_samples. k_I_up< 12;
below_baseline = parameter_samples.k_I_sec < 10;
above_baseline = ~below_baseline;

%  scatter(parameter_samples.k_I_up(below_baseline), max_Gout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
% scatter(parameter_samples.k_I_up(above_baseline), max_Gout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);
 
scatter(parameter_samples.k_I_sec(below_baseline), max_Gout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
scatter(parameter_samples.k_I_sec(above_baseline), max_Gout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);


 % xlabel('k_I_up');
xlabel('k_{I_{sec}}');

ylabel('G');
% title('Correlation: G vs. k_I_up');
title('Correlation: G vs. k_{I_{sec}}');
grid on;

% Compute correlation coefficient
% [R1, P1] = corrcoef(parameter_samples.k_I_up, max_Gout);
[R1, P1] = corrcoef(parameter_samples.k_I_sec, max_Gout);

% Perform linear regression
 % p1 = polyfit(parameter_samples.k_I_up, max_Gout, 1); % Linear fit (y = mx + b)
 % yfit1 = polyval(p1, parameter_samples.k_I_up);

p1 = polyfit(parameter_samples.k_I_sec, max_Gout, 1); % Linear fit (y = mx + b)
yfit1 = polyval(p1, parameter_samples.k_I_sec);

% Plot regression line
 % plot(parameter_samples.k_I_up, yfit1, 'k', 'LineWidth', 1);

% Plot regression line
 plot(parameter_samples.k_I_sec, yfit1, 'k', 'LineWidth', 1);

% Display correlation coefficient & regression equation
% text(mean(parameter_samples.k_I_up), max(max_Gout) * 0.9, ...
%     sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
%     'FontSize', 12, 'FontWeight', 'bold');


text(mean(parameter_samples.k_I_sec), max(max_Gout) * 0.9, ...
   sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
    'FontSize', 12, 'FontWeight', 'bold');

% hold off;% 
% 
figure(2)
tiledlayout(1,2);
%% -------------------- Top Left: correlation max Insulin --------------------%%
nexttile;
hold on; grid on;
xlabel('Time');
ylabel('Insulin');
title('Sensitivity Analysis: Insulin');

% Run simulations for sampled k_prost values
for i = 1:num_samples
    % k_I_up = parameter_samples. k_I_up(i);
    k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
 max_Iout(i) = max(Iout); % Store max G

%   if k_I_up < 12
    if k_I_sec < 10
    
    plot(tiempo,Iout,'Color', [0.49, 0.18, 0.56]); % Lower than baseline in purple
    else
        plot(tiempo,Iout,'Color', [0.26, 0.62, 0.32]); % Normal or above baseline in black
    end


end

% Run baseline simulation
% k_I_up=12;
k_I_sec = 10;
sim('Sim_Metabolico_Param.slx'); 
 plot(tiempo,Iout,'r', 'LineWidth', 2); % Baseline in red
 % hold off;


%% -------------------- Bottom Left: Correlation (Max I vs. k_I_sec) --------------------
nexttile;
hold on;
% below_baseline = parameter_samples.k_I_up < 12;
below_baseline = parameter_samples.k_I_sec < 10;
above_baseline = ~below_baseline;

% scatter(parameter_samples.k_I_up(below_baseline), max_Iout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
% scatter(parameter_samples.k_I_up(above_baseline), max_Iout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);

scatter(parameter_samples.k_I_sec(below_baseline), max_Iout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
scatter(parameter_samples.k_I_sec(above_baseline), max_Iout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);


 % xlabel('k_I_up');
xlabel('k_{I_{sec}}');

ylabel('I');
title('Correlation: I vs. k_{I_{sec}}');

%title('Correlation: I vs. k_I_sec');
grid on;

% Compute correlation coefficient
% [R1, P1] = corrcoef(parameter_samples.k_I_up, max_Iout);
[R1, P1] = corrcoef(parameter_samples.k_I_sec, max_Iout);

% Perform linear regression
% p1 = polyfit(parameter_samples.k_I_up, max_Iout, 1); % Linear fit (y = mx + b)
% yfit1 = polyval(p1, parameter_samples.k_I_up);
% 
p1 = polyfit(parameter_samples.k_I_sec, max_Iout, 1); % Linear fit (y = mx + b)
yfit1 = polyval(p1, parameter_samples.k_I_sec);

% Plot regression line
 % plot(parameter_samples.k_I_up, yfit1, 'k', 'LineWidth', 1);

% Plot regression line
plot(parameter_samples.k_I_sec, yfit1, 'k', 'LineWidth', 1);

% Display correlation coefficient & regression equation

% text(mean(parameter_samples.k_I_up), max(max_Iout) * 0.9, ...
%     sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
%     'FontSize', 12, 'FontWeight', 'bold');
% 

text(mean(parameter_samples.k_I_sec), max(max_Iout) * 0.9, ...
    sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
    'FontSize', 12, 'FontWeight', 'bold');

% hold off;

figure(3)
 tiledlayout(1,2);
%% -------------------- Top Left: Beta --------------------%%
nexttile;
hold on; grid on;
xlabel('Time');
ylabel('Beta');
title('Sensitivity Analysis: Beta');

% Run simulations for sampled k_prost values
for i = 1:num_samples
    % k_I_up = parameter_samples.k_I_up(i);
    k_I_sec= parameter_samples.k_I_sec(i);
    sim('Sim_Metabolico_Param.slx'); 
 
    max_Bout(i) = max(Bout); % Store max B

     % if k_I_up < 12
    if k_I_sec < 10
    
    plot(tiempo,Bout,'Color', [0.49, 0.18, 0.56]); % Lower than baseline in purple
    else
        plot(tiempo,Bout,'Color', [0.26, 0.62, 0.32]); % Normal or above baseline in black
    end


end

% Run baseline simulation
% k_I_up=12;
k_I_sec = 10;
sim('Sim_Metabolico_Param.slx'); 
 plot(tiempo,Bout, 'r', 'LineWidth', 2); % Baseline in red


% 
 hold off;

%% -------------------- Bottom Left: Correlation (Max B vs. k_I_sec) --------------------
nexttile;
hold on;
 % below_baseline = parameter_samples.k_I_up< 12;
below_baseline = parameter_samples.k_I_sec < 10;
above_baseline = ~below_baseline;

% scatter(parameter_samples.k_I_up(below_baseline), max_Bout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
% scatter(parameter_samples.k_I_up(above_baseline), max_Bout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);

scatter(parameter_samples.k_I_sec(below_baseline), max_Bout(below_baseline), 'o', 'filled','MarkerEdgeColor', [0.49, 0.18, 0.56],'MarkerFaceColor', [0.49, 0.18, 0.56]);
scatter(parameter_samples.k_I_sec(above_baseline), max_Bout(above_baseline), 'o', 'filled','MarkerEdgeColor', [0.26, 0.62, 0.32],'MarkerFaceColor',[0.26, 0.62, 0.32]);


 % xlabel('k_I_up');
xlabel('k_{I_{sec}}');

ylabel('B');
title('Correlation: B vs. k_{I_{sec}}');
grid on;

% Compute correlation coefficient
% [R1, P1] = corrcoef(parameter_samples.k_I_up, max_Bout);
[R1, P1] = corrcoef(parameter_samples.k_I_sec, max_Bout);

% Perform linear regression
% p1 = polyfit(parameter_samples.k_I_up, max_Bout, 1); % Linear fit (y = mx + b)
% yfit1 = polyval(p1, parameter_samples.k_I_up);

p1 = polyfit(parameter_samples.k_I_sec, max_Bout, 1); % Linear fit (y = mx + b)
yfit1 = polyval(p1, parameter_samples.k_I_sec);

% Plot regression line
% plot(parameter_samples.k_I_up, yfit1, 'k', 'LineWidth', 1);

% Plot regression line
 plot(parameter_samples.k_I_sec, yfit1, 'k', 'LineWidth', 1);

% Display correlation coefficient & regression equation
% text(mean(parameter_samples.k_I_up), max(max_Bout) * 0.9, ...
%     sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
%     'FontSize', 12, 'FontWeight', 'bold');


text(mean(parameter_samples.k_I_sec), max(max_Bout) * 0.9, ...
    sprintf('R = %.3f', R1(1,2), p1(1), p1(2)), ...
    'FontSize', 12, 'FontWeight', 'bold');

% hold off;
toc