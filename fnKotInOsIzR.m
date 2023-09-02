function [phi, v] = fnKotInOsIzR(R)

phi = acos((trace(R)-1)/2)*180/pi;
v = [R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)]/2/sin(phi);

