% Fits ellipse to generated noisy points
% Rishav (2020/6/15)
clc
clear 
close all

%%% Generate ellipse
a = 15;
b = 5;
t = linspace(0,2*pi,50);
x = 10 + a*cos(t);
y = 5 + b*sin(t);

% Add noise
SNR = 20;
x = awgn(x,SNR); 
y = awgn(y,SNR); 

% Fit ellipse to generated points
v = ellipseFit(x',y');

% Plot 
plot(x,y,'.','MarkerSize',10); % Noisy input
hold on;
plotEllipse(v);

                  
