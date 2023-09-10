function [position,comulative_position, leaky_integrator_position] = fnGetPosition(velocity,deltaT,lambda)
    % Compute each individual position(s).
    position = velocity * deltaT;

    comulative_position = zeros(position);
    leaky_integrator_position = zeros(position);
    
    if length(position) > 1
        % Compute comulative position(s).
        for i = 2:length(position)
            comulative_position(i) = position(i) + position(i - 1);
        end
        % Compute positions with leaky intergrator.
        leaky_integrator_position = fnLeakyIntegrator(position,lambda);
    end
end

