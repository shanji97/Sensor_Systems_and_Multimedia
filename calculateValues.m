function [v, deltaT, phi, R, g] = calculateValues(om, t, g)
    numSamples = length(om);
    v = om(1,:);
    for i = 1:numSamples - 1
            v = om(i,:);
            deltaT = t(i+1)-t(i);
            phi = -norm(v)*deltaT*180/pi;
            v = v/norm(v);    
        R = fnRotacijskaMatrika(phi,v);
        g(i+1,:) = (R*g(i,:)')';
    end
end