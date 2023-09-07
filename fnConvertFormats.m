function [GYRODATA,ACCDATA] =fnConvertFormats(gyroFile, accFile, appName, defaultSamplingFrequency)
   
    gyroTable = readtable(gyroFile);
    accTable = readtable(accFile);
%     %Based on the app used in the experiment, return the apropriate,
    %format.
    if strcmp(appName,'stock')
     %TODO: change the column to "epoch".
     GYRODATA  = gyroTable;
     ACCDATA = accTable;
    elseif strcmp(appName,'phyphox')

        %% Compute the Acceleration
    
        %Compute the epoch and the timestamp based on the:
        % -We know the creation of the CSV file.
        % -At which second from the start the computation was made
        % -The frequency at which the computation was made
        format longG

        elapsed_time_s = (0:(height(accTable)-1)) / defaultSamplingFrequency;
        data_creation_timestamp = datetime(dir(accFile).date, 'InputFormat', 'dd-MMM.-yyyy HH:mm:ss');
        timestamp_formatted = datestr(data_creation_timestamp, 'yyyy-MM-ddTHH.mm.ss');
        unix_epoch_time_ms = posixtime(data_creation_timestamp) * 1000 + elapsed_time_s * 1000;

        % Remap the data to fit "our" notation.
        g = 9.81;
        ACCDATA = table(unix_epoch_time_ms', repmat({timestamp_formatted}, height(accTable), 1), elapsed_time_s', ...
    accTable.('AccelerationX_m_s_2_') / g, accTable.('AccelerationY_m_s_2_') /g, accTable.('AccelerationZ_m_s_2_') / g, ...
    'VariableNames', {'epoch', 'timestamp', 'elapsed (s)', 'x-axis (g)', 'y-axis (g)', 'z-axis (g)'});
        %% Compute the Gyroscope data
        % Essentialy the same approach, just convert rad to deg.

        elapsed_time_s = (0:(height(gyroTable)-1)) / defaultSamplingFrequency;
        data_creation_timestamp = datetime(dir(gyroFile).date, 'InputFormat', 'dd-MMM.-yyyy HH:mm:ss');
        timestamp_formatted = datestr(data_creation_timestamp, 'yyyy-MM-ddTHH.mm.ss');
        unix_epoch_time_ms = posixtime(data_creation_timestamp) * 1000 + elapsed_time_s * 1000;

        gyro_x_deg_per_s = rad2deg(gyroTable.('GyroscopeX_rad_s_'));
        gyro_y_deg_per_s = rad2deg(gyroTable.('GyroscopeY_rad_s_'));
        gyro_z_deg_per_s = rad2deg(gyroTable.('GyroscopeZ_rad_s_'));

        GYRODATA = table(unix_epoch_time_ms', repmat({timestamp_formatted}, height(gyroTable), 1), elapsed_time_s', ...
        gyro_x_deg_per_s, gyro_y_deg_per_s, gyro_z_deg_per_s, ...
        'VariableNames', {'epoch', 'timestamp', 'elapsed (s)', 'x-axis (deg/s)', 'y-axis (deg/s)', 'z-axis (deg/s)'});
    
    end


end