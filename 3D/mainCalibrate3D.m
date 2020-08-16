% 3D magnetometer calibration based on ellipsoid fitting
% 2020/06/03
clc
clear
close all

% Import magnetometer values
file = 'raw.txt'; 
raw = importdata(file);

% Uncalibrated data
x = raw(:,1); 
y = raw(:,2); 
z = raw(:,3);

% Calibrated data 
X = zeros(length(x),1); 
Y = zeros(length(x),1); 
Z = zeros(length(x),1);

%%% Ellipsoid fit
% v = [a;b;c;f;g;h;p;q;r;d]
% M = [a h g; h b f; g f c]
% n = [p; q; r]
v = ellipsoidFit(x,y,z); 
M = [v(1),v(6),v(5);v(6),v(2),v(4);v(5),v(4),v(3)];
n = [v(7);v(8);v(9)];
d = v(10);

%%% Matrices for calibration equation
Ainv    = real((1/sqrt(n'*(M\n)-d))*sqrt(M));
b       = -M\n;

% For every data
for i_iters = 1:length(x)
    % Sensor data
    h_m = [x(i_iters); y(i_iters); z(i_iters)]; 
    
    %%% Calibration
    h_hat = Ainv*(h_m-b); 
    
    % Calibrated values
    X(i_iters) = h_hat(1);
    Y(i_iters) = h_hat(2);
    Z(i_iters) = h_hat(3);
end
    
%%% Plot
% Uncalibrated data
figure('name','Uncalibrated magnetometer data')
plotEllipsoid(v);
hold on;
scatter3(x,y,z,'fill','MarkerFaceColor','red');
title({'Before magnetometer calibration','(Ellipsoid fitted)'});
xlabel('h_m_x (nT)');
ylabel('h_m_y (nT)');
zlabel('h_m_z (nT)');
axis equal;
% Turn off the normal axes
% set(gca, 'NextPlot','add', 'Visible','off');

% Calibrated data
figure('name','Calibrated magnetometer data') 
scatter3(X,Y,Z,'fill','MarkerFaceColor','blue');
title({'After magnetometer calibration','(Normalized to unit circle)'});
axis equal;
hold on
plotSphere([0,0,0],1);
% Turn off the normal axes
% set(gca, 'NextPlot','add', 'Visible','off');

%%% Print calibration matrices
fprintf('3D magnetometer calibration based on ellipsoid fitting');
fprintf('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
fprintf('\nThe calibration equation to be implemented in mcu:') 
fprintf('\n\t\t\t\th_hat = Ainv*(h_m - b) \nWhere,')
fprintf('\nh_m   = Measured sensor data vector');
fprintf('\nh_hat = Calibrated sensor data vector');
fprintf('\n\nAinv =\n'); disp(Ainv);
fprintf('\nb      =\n'); disp(b);


