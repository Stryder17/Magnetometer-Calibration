function [] = plotEllipse(v)
  % https://en.wikipedia.org/wiki/Matrix_representation_of_conic_sections
  % Rishav (2020/6/16)
  % Quadratic general equation: ax^2 + bxy + cy^2 + dx + ey + f = 0 
 
  % Unpack ellipse coefficients
  a = v(1);
  b = v(2);
  c = v(3);
  d = v(4);
  e = v(5);
  f = v(6);
  
  M = [a b/2; b/2 c];
  
  % Semi axis lengths using eigen values and f
  [~,eval] = eig(M);
  ab          = [eval(1,1) eval(2,2)];
  a  = sqrt(abs(f)/min(abs(ab)));
  b  = sqrt(abs(f)/max(abs(ab)));
  
  % Center of ellipse
  x = [-d/2, -e/2]';
  M = [a b/2; b/2 c];
  center = M\x;
  
  % Coordinate of centre
  xc = center(1);
  yc = center(2);
  
  %%% Compute angle of rotation of ellipse
  two_theta     = atan(b/(a-c));
  cos_theta = sqrt((1 + cos(two_theta))/2);
  sin_theta = sqrt((1 - cos(two_theta))/2);
  
  %%% Generate ellipse
  t = linspace(0,2*pi,50);
  
  % Parametric equation of rotated ellipse
  x = xc + a*cos(t)*cos_theta;
  y = yc + b*sin(t)*sin_theta;
  plot(x,y); 
end
