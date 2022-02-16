
 function [x] = SinusoidalMap(Max_iter)
 x(1)=rand; 
for i=1:Max_iter
     x(i+1) = 2.3*x(i)^2*sin(pi*x(i));
 end
 end