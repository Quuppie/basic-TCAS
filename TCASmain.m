
%{

Inputs: TCAS_A and TCAS_B

Outputs: v_x1,v_x2,v_y1,v_y2 (Plots vs. time)
        Collision - General warning parameters (t and dx)
        WARNINGS ! 
        Resolution

%}

%% Notes
%Check that the distance can be extrapolated!
%POSSIBLY - LINES FOR EACH X,Y - Then take distance of these
%extrapolations.

clear; clc; close all;

%% Data Processing
%Decided to throw into one matrix + grab from there

Data_A = readmatrix("Data_TCAS_A.csv");
Data_B = readmatrix("Data_TCAS_B.csv");

TCAS_Template = zeros(96,6);
TCAS_Hold = TCAS_Template;
TCAS_Hold(24:84,1:3) = Data_A;
TCAS_Hold(36:end,4:5) = Data_B(:,2:3);
TCAS_Hold(84:end, 1) = Data_B(49:end,1);  %PLEASE Figure out at way to not hard-code this

x_a = TCAS_Hold(36:84,2);
x_b = TCAS_Hold(36:84,4);

y_a = TCAS_Hold(36:84,3);
y_b = TCAS_Hold(36:84,5);


t_ab = TCAS_Hold(36:84,1);
t_plot = (1:1:length(t_ab))';
t_projection = (-42:1:142)';

%Polyval LOBF for Ax
[p_ax,S_ax] = polyfit(t_projection(1:length(x_a)),x_a,1);

[fit_ax, delta_ax] = polyval(p_ax,t_projection,S_ax);

%Polyval LOBF for Bx
[p_bx,S_bx] = polyfit(t_projection(1:length(x_b)),x_b,1);

[fit_bx, delta_bx] = polyval(p_bx,t_projection,S_bx);

%Polyval LOBF for Ay
[p_ay,S_ay] = polyfit(t_projection(1:length(y_a)),y_a,1);

[fit_ay, delta_ay] = polyval(p_ay,t_projection,S_ay);

%Polyval LOBF for By
[p_by,S_by] = polyfit(t_projection(1:length(y_b)),y_b,1);

[fit_by, delta_by] = polyval(p_by,t_projection,S_by);

%% DETECTION LOOP

statevector = [(x_b-x_a), (y_b-y_a)];
projected_statevector = [(fit_bx-fit_ax), (fit_by-fit_ay)];

TCAS_Dist = zeros(size(t_plot,1),1);

for i = 1:size(t_plot)
    TCAS_Dist(i) = norm(statevector(i));
end

TCAS_Dist_Projected = zeros(size(t_projection,1),1);
for i = 1:size(t_projection)
    TCAS_Dist_Projected(i) = norm(projected_statevector(i));
end

%{
if TCAS_Dist <= 3.3   
%}

%POLYFIT FOR THE DISTANCE
[p_TCAS,S_TCAS] = polyfit(t_plot,TCAS_Dist,1);

[fit_TCAS, delta_TCAS] = polyval(p_TCAS,t_projection,S_TCAS);

%Plotting for Checkin

f1 = figure();
plot(t_plot,x_a,t_plot,fit_ax(1:length(t_plot)),t_plot,x_b,t_plot,fit_bx(1:length(t_plot)));        %For memez
xlabel('Time (s)');
ylabel('x (nm)');
legend ('xa', 'xb', 'fita', 'fitb')

f2 = figure();
plot(t_plot,y_a,t_plot,fit_ay(1:length(t_plot)),t_plot,y_b,t_plot,fit_by(1:length(t_plot)));
xlabel('Time (s)');
ylabel('y (nm)')
legend ('ya', 'yb', 'fita', 'fitb')

%% The real one - 
f4 = figure();
scatter(t_plot,TCAS_Dist);
hold on
plot(t_projection,fit_TCAS);
plot(t_projection,fit_TCAS+delta_TCAS,'m--',t_projection,fit_TCAS-delta_TCAS,'m--');
yline(3.3, '--g');
yline(2.0, ':r');
yline(0, 'LineWidth', 2)


f5 = figure();
scatter(x_a,y_a);
hold on
scatter(x_b,y_b);
plot(fit_ax(1:length(t_projection)),fit_ay(1:length(t_projection)),fit_bx(1:length(t_projection)),fit_by(1:length(t_projection))); % X element
% plot(t_projection,fit_TCAS);
% plot(t_projection,fit_TCAS+delta_TCAS,'m--',t_projection,fit_TCAS-delta_TCAS,'m--');

f6 = figure();
plot(t_projection,TCAS_Dist_Projected(:,1));

xlabel('X Position (nm)');
ylabel('Y Position (nm)');

%% ERROR ANALYSIS

%Deriving Dmin
%{
Defining some vars
x_a0 = 
x_b0 = 
y_a0 =
y_b0 = 
ux_a = 
ux_b = 
etc. 
t_ca = (-(x_b0-x_a0).*(ux_b-ux_a) - (y_b0-y_a0).*(vy_b-vy_a)) / ((ux_b-ux_a).^2 + (vy_b - vy_a).^2)
%}

%% DANGER ZONE (RESULT)

% TRAFFIC TRAFFIC 

% CLIMB CLIMB CLIMB

% DESCEND DESCEND NOW

% CROSSING

% CLEAR OF TARGET

%[audiodat,Fs] = readaudio(TCAS_Warning.mp3);

%something visual???
%https://youtu.be/W5Z-d1Zx02o?si=Z7Dbl9Z7zXkLh2-P
%% WARNING LOOP





%% ERROR LOOP