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
f = v(4) ;
g = v(5) ;
h = v(6) ;
p = v(7) ;
q = v(8) ;
r = v(9) ; 
d = v(10); 

M =[a h g; h b f; g f c];

% Eigenvalues of matrix M 
[~,eval] = eig(M);

% Semi axis lengthes using eigen values and d
a = sqrt(abs(d)/eval(1,1))
b = sqrt(abs(d)/eval(2,2))
c = sqrt(abs(d)/eval(3,3))

% Centre of the ellipsoid
x = [-p, -q, -r]';
centre = M\x;

% Coordinate of centre
xc = centre(1)
yc = centre(2)
zc = centre(3)

%%% Plot ellipsoid
% Parametric equations of ellipsoid:
% x	=	a*cosu*sinv 	
% y	=	b*sinu*sinv	
% z	=	c*cosv
% u in [0,2pi) and v in [0,pi]
theta = linspace(0,2*pi,20);
phi = linspace(0,pi,20);
[theta,phi] = meshgrid(theta,phi);

x = xc + a*cos(theta).*cos(phi);
y = yc + b*cos(theta).*sin(phi);
z = zc + c*sin(theta);

mesh(x,y,z,'FaceAlpha','0.5')
axis equal
hold on;
end