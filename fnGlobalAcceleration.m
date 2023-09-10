function acc_lin_final = fnGlobalAcceleration(v,t,phi,R,acc_lin,om_corrected)
    % Check array lengths
    %disp(['Length of om: ' num2str(length(om_corrected))]);   
    %disp(['Length of acc: ' num2str(length(acc_lin))]);
    %disp(['Length of t: ' num2str(length(t))]);

    % Determine the size of the acc_lin array
    [num_rows, num_cols] = size(acc_lin);
    
    % Initialize acc_lin_final with zeros of the same size as acc_lin
    acc_lin_final = zeros(num_rows, num_cols);

    for i = 1:(length(om_corrected) - 1) % Adjust the loop bound
        v = om_corrected(i,:);
        deltaT = t(i+1) - t(i);
        phi = norm(v) * deltaT * 180/pi;
        v = v / norm(v);
        R = fnRotacijskaMatrika(phi, v);
        acc_lin_final(i+1,:) = (R * acc_lin(i,:)')';
    end
end
