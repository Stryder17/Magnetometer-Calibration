% Test of ellipsoidFit.m function
% Rishav (2020)
clc
clear 
close all

%%% Generate test points
% x	=	a*cosu*sinv 	
% y	=	b*sinu*sinv	
% z	=	c*cosv
% u in [0,2pi) and v in [0,pi]
[u, v] = meshgrid(0:0.3:pi*2,0:0.3:pi);
a = 15; 
b = 8; 
c = 6;
xc = 10*0;
yc = 10*0;
zc = 10*0;

% Parametric equations of ellipsoids 
x = xc + a*cos(u).*cos(v);
y = yc + b*cos(u).*sin(v);
z = zc + c*sin(u);
x=x(:); y=y(:); z=z(:);

% Add noise to generated points
SNR = 30;
x = awgn(x,SNR,'measured');
y = awgn(y,SNR,'measured');
z = awgn(z,SNR,'measured');

v = ellipsoidFit(x,y,z);

% Plot and camera settings
% set(gca,'NextPlot','add', 'Visible','off');
view(59,13); hold on
 
plotEllipsoid(v);
plot3(x,y,z,'.');

