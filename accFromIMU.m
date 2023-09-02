function [acc_lin] = accFromIMU(om,acc)
    figure;
    plot(om);

    om_static_i = ginput(2); om_static_i = round(om_static_i);
    om_0 = mean(om(om_static_i(1):om_static_i(2), :));
    om_corrected = om - om_0;

    figure;
    plot(acc);

    figure;
    plot(acc);

    acc_static_i = ginput(2); acc_static_i = round(acc_static_i);
    
    acc_0 = mean(acc(acc_static_i(1):acc_static_i(2), :));

    acc_corrected = acc - acc_0;

    g_sens = acc_0/norm(acc_0);

    for i = 1:length(om)-1
        v = om(i,:);
        deltaT = t(i+1)-t(i);
        phi = -norm(v)*deltaT*180/pi;
        v = v/norm(v);    
        R = fnRotacijskaMatrika(phi,v);
        g_sens(i+1,:) = (R*g_sens(i,:)')';
    end
    acc_lin = acc_corrected - g_sens;
end