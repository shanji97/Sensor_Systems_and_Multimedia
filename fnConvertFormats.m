function [GYRODATA,ACCDATA] =fnConvertFormats(gyroFile, accFile, appName, defaultSamplingFrequency)
   
    gyrotable = readtable(gyroFile);
    accTable = readtable(accFile);


    %Based on the app used in the experiment, return the apropriate,
    %format.
    if strcmp(appName,'stock')
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
        data_creationTimeStamp = datetime(dir(accFile).date, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
        timestamp_formatted = datestr(data_creation_timestamp, 'yyyy-MM-ddTHH.mm.ss.SSS');
      
        % Remap the data to fit "our" notation.
        ACCDATA = table(unix_epoch_time_ms', repmat({timestamp_formatted}, height(dataTable), 1), elapsed_time_s', ...
    accTable.('Acceleration x (m/s^2)') / g, accTable.('Acceleration y (m/s^2)') /g, accTable.('Acceleration z (m/s^2)') / g, ...
    'VariableNames', {'epoc (ms)', 'timestamp (+0100)', 'elapsed (s)', 'x-axis (g)', 'y-axis (g)', 'z-axis (g)'});

       
        %% Compute the Gyroscope data
        % Essentialy the same approach, just convert rad to deg.

        elapsed_time_s = (0:(height(gyrotable)-1)) / defaultSamplingFrequency;
        data_creationTimeStamp = datetime(dir(gyroFile).date, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
        timestamp_formatted = datestr(data_creation_timestamp, 'yyyy-MM-ddTHH.mm.ss.SSS');

        gyro_x_deg_per_s = rad2deg(gyrotable.('Gyroscope x (rad/s)'));
        gyro_y_deg_per_s = rad2deg(gyrotable.('Gyroscope y (rad/s)'));
        gyro_z_deg_per_s = rad2deg(gyrotable.('Gyroscope z (rad/s)'));

        GYRODATA = table(unix_epoch_time_ms', repmat({timestamp_formatted}, height(gyroDataTable), 1), elapsed_time_s', ...
        gyro_x_deg_per_s, gyro_y_deg_per_s, gyro_z_deg_per_s, ...
        'VariableNames', {'epoc (ms)', 'timestamp (+0100)', 'elapsed (s)', 'x-axis (deg/s)', 'y-axis (deg/s)', 'z-axis (deg/s)'});
    
    end


end