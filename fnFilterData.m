function [omFilt, accFilt] = fnFilterData(acc, om, fs, fco)
    % Apply Butterworth filter to gyroscope data
    [b, a] = butter(6, fco / (fs / 2));  % 6th-order Butterworth filter
    omFilt = filtfilt(b, a, om);

    % Apply Butterworth filter to accelerometer data
    accFilt = filtfilt(b, a, acc);
end