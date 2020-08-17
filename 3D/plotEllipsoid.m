function [] = plotEllipsoid(v)
% Plots ellipsoid from coefficients of general quadrics equation
% Result of whole night discussion with Manjul (2020/6/8-9) 
%
% Input:
%   v = [a,b,c,f,g,h,p,q,r,d], a vector corresponding to coefficients of 
%       the general quadric surface given by equation,  
%       ax2 + by2 + cz2 + 2fyz + 2gxz + 2hxy + 2px + 2qy + 2rz + d = 0.
% 
% Rishav (2020/6/8)

% Unpack ellipsoid coefficients
a = v(1) ;
b = v(2) ;
c = v(3) ;
f = v(4) 
g = v(5) 
h = v(6) 
p = v(7) ;
q = v(8) ;
r = v(9) ; 
d = v(10); 

M =[a h g; h b f; g f c];
% Q = [a h g p; h b f q; g f c r; p q r d];

a_ = sqrt(p^2/a^2 + q^2/(a*b) + r^2/(a*c) - d/a)
b_ = sqrt(p^2/(a*b) + q^2/b^2 + r^2/(b*c) - d/b)
c_ = sqrt(p^2/(a*c) + q^2/(b*c) + r^2/c^2 - d/c)

% Centre of the ellipsoid
x = [-p, -q, -r]';
centre = M\x

% New coordinates basis where ellipsoid is not rotating
% **Left hand coordinate sys to right hand conversion
[evec,eval] = eig(M) 


x_ = evec(:,1); 
y_ = evec(:,2);
z_ = evec(:,3);
if det(evec)<0
    x_ = -evec(:,1); % **
end

% Old coordinate system
x = [1 0 0]';
y = [0 1 0]';
z = [0 0 1]';

% DCM (Inertial(x,y,z)->Body(x_,y_,z_))
C  = [dot(x_,x) dot(x_,y) dot(x_,z); ...
        dot(y_,x) dot(y_,y) dot(y_,z); ...
        dot(z_,x) dot(z_,y) dot(z_,z)]

disp(det(C)) % Check left handed or right handed system

C11 = C(1,1);
C12 = C(1,2);
C23 = C(2,3);
C13 = C(1,3);
C33 = C(3,3);

% Prevent NaN
if C33 == 0
    C33 = 0.00001;
end
if C11 == 0
    C11 = 0.00001;
end
    
% DCM to Euler angles (3-2-1) 
% yaw = atan2(C12,C11)   % four-quadrant inverse tangent
% pitch = -asin(C13)    
% roll =  atan2(C23,C33) 

% Coordinate of centre
xc = centre(1);
yc = centre(2);
zc = centre(3);

%%% Plot ellipsoid
% Parametric equations of ellipsoid:
% x	=	a*cosu*sinv 	
% y	=	b*sinu*sinv	
% z	=	c*cosv
% u in [0,2pi) and v in [0,pi]
theta = linspace(0,2*pi,20);
phi = linspace(0,pi,20);
[theta,phi] = meshgrid(theta,phi);

x = a_*cos(theta).*cos(phi);
y = b_*cos(theta).*sin(phi);
z = c_*sin(theta);

% Rotate using DCM (321)
% for i_iters = 1: length(x)
%      old = [x(i_iters),y(i_iters),z(i_iters)]';
%      new = C*old;
%      x(i_iters) = new(1);
%      y(i_iters) = new(2);
%      z(i_iters) = new(3);
% end

x = xc + x;
y = yc + y;
z = zc + z;

mesh(x,y,z,'FaceAlpha','0.5')
axis equal
hold on;
end