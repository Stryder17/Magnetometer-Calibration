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
a = v(1);
b = v(2);
c = v(3);
f = v(4); 
g = v(5); 
h = v(6); 
p = v(7);
q = v(8);
r = v(9); 
d = v(10); 

M =[a h g; h b f; g f c];
% Q = [a h g p; h b f q; g f c r; p q r d];

[evec,eval]=eig(M)
disp(det(-evec));
C = evec;
M_ = C'*M*C;
a_ = M_(1,1);
b_ = M_(2,2);
c_ = M_(3,3);
pqr_ = [p,q,r]*C;   
p_ = pqr_(1);
q_ = pqr_(2);
r_ = pqr_(3);
d_ = d;

ax_ = sqrt(p_^2/a_^2 + q_^2/(a_*b_) + r_^2/(a_*c_) - d_/a_);
bx_ = sqrt(p_^2/(a_*b_) + q_^2/b_^2 + r_^2/(b_*c_) - d_/b_);
cx_ = sqrt(p_^2/(a_*c_) + q_^2/(b_*c_) + r_^2/c_^2 - d_/c_);

theta = linspace(0,2*pi,20);
phi = linspace(0,pi,20);
[theta,phi] = meshgrid(theta,phi);

x_ = ax_*cos(theta).*cos(phi);
y_ = bx_*cos(theta).*sin(phi);
z_ = cx_*sin(theta);

% mesh(x_,y_,z_,'FaceAlpha','0.5')
% axis equal
hold on;

x_ = x_(:);
y_ = y_(:);
z_ = z_(:);

% Centre of the ellipsoid
centre = M\[-p, -q, -r]';

for i_iters = 1:length(x_)
    after_rot = C*[x_(i_iters), y_(i_iters), z_(i_iters)]';
    x_(i_iters) = centre(1) + after_rot(1);
    y_(i_iters) = centre(2) + after_rot(2);
    z_(i_iters) = centre(3) + after_rot(3);
end  

plot3(x_,y_,z_); % Input points
end