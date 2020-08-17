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

% a = 10; 
% b = 10; 
% c = 50;
% xc = 10;
% yc = 100;
% zc = 10;

% Rotation angles of the ellipsoid (3-2-1 Euler angles) 
yaw = 0; 
pitch = 0; 
roll = 0; % ROll

a = 10; 
b = 20; 
c = 30;
xc = 10;
yc = 15;
zc = 10;

% Parametric equations of ellipsoids 
x = a*cos(u).*cos(v);
y = b*cos(u).*sin(v);
z = c*sin(u);
x=x(:); y=y(:); z=z(:); % Meshgrid to vector
xyz = [x y z];

% Rotate using DCM (321)
C = dcm321Euler(yaw,pitch,roll)
for i_iters = 1: length(x)
     new = C*xyz(i_iters,:)';
     xyz(i_iters,:) = new'; 
end

x = xc + xyz(:,1);
y = yc + xyz(:,2);
z = zc + xyz(:,3);

% Add noise to generated points
SNR = 100;
x = awgn(x,SNR,'measured');
y = awgn(y,SNR,'measured');
z = awgn(z,SNR,'measured');

%%% Ellipse fit algoritm
v = ellipsoidFit(x,y,z);

% Plot and camera settings
% set(gca,'NextPlot','add', 'Visible','off');
view(59,13); hold on

%%% Plot
plotEllipsoid(v); % Estimated ellipse
plot3(x,y,z,'.'); % Input points