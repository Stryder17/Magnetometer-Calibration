function v = ellipseFit(x,y)
% Implementation of least squares elipse fit algorithm
%
% Inputs:
%   x = Column vector of data corresponting to x coordinates of input data.
%   y = Column vector of data corresponting to y coordinates of input data.
%
% Outputs:
%   v = [a,b,c,d,e,f], a row vector corresponding to coefficitents of the 
%       general conic given by equation, 
%       ax^2 + bxy + cy^2 + dx + ey + f = 0 
%       
% Source:
%   Halir - Numerically Stable Direct Least Squares Fitting of Ellipses
%
% Rishav (2020/6/15)

D1 = [x.*x, x.*y, y.*y];            % Quadratic part of design matrix
D2 = [x, y, ones(length(x),1)];     % Linear part of design matrix
S1 = D1'*D1;                        % Quadratic part of scatter matrix
S2 = D1'*D2;                        % Combined part f scatter matrix
S3 = D2'*D2;                        % Linear part of the scatter matrix
T  = -S3\S2';                        % For getting a2 from a1
M = S1 + S2*T;                      % Reduced scatter matrix
M = [M(3,:)./2;-M(2,:);M(1,:)./2];  % Premultiply by inv(C1)
[evec,~] = eig(M);               % Solve eigensystem
cond  = 4*evec(1, :).*evec(3, :) - evec(2, :).*evec(2, :); % Evaluate a’Ca
a1    = evec(:, cond > 0);   % Eigenvector for min. pos. eigenvalue
v     = [a1; T*a1];                % Ellipse coefficients

end
