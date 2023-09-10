function [position, comulative_position] = fnGetPosition(velocity, deltaT)
    % Compute each individual position(s).
    position = velocity * deltaT;
    
    % Determine the size of comulative_position based on the length of position
    num_positions = length(position);
    
    % Initialize comulative_position with zeros of the same size as position
    comulative_position = zeros(1, num_positions);

    if num_positions > 1
        % Compute cumulative position(s).
        for i = 2:num_positions
            comulative_position(i) = position(i) + position(i - 1);
        end    
    end
end

