%f1 = phone (Pixel 4a 5G), f2 = phone (Galaxy A53 G).
app = 'phyphox'; % Options: "phyphox", "stock" (as by SSM meausurements).
defaultSampling = 500; % Hz
% CutOff frequency:
fco_f1 = 159.49 %https://www.st.com/resource/en/datasheet/lsm6dsr.pdf, p. 30 + linear interpolation
fco_f2 = 456.67 % https://eu.mouser.com/datasheet/2/389/lsm6dso-1393615.pdf, p. 30 + linear interpolation

% Weighting which sensor is used more. In this case we add more weight to
% the gyro. Ideal 0.9 - 0.98.
lambda = 0.98
%Distance = 40.3cm/tile 23 tiles in one direction (one path 46 tiles  ~
%18.538m
accFileName_f1     = "f1_accel.csv";
accFileName_f2     = "f2_accel.csv";

gyroFileName_f1     = "f1_gyro.csv";
gyroFileName_f2     = "f2_gyro.csv";

fs = (defaultSampling * 2) + 1;

%% Import IMU signals from f1 and f2 files and convert it to our notation.
[ACCDATA_f1, GYRODATA_f1]         = fnConvertFormats(gyroFileName_f1,accFileName_f1,app,defaultSampling);
[acc_f1, om_f1, t_f1, t0_f1] = fnSyncAccOmMW(ACCDATA_f1, GYRODATA_f1, fs);

[ACCDATA_f2, GYRODATA_f2]         = fnConvertFormats(gyroFileName_f2,accFileName_f2,app,defaultSampling);
[acc_f2, om_f2, t_f2, t0_f2] = fnSyncAccOmMW(ACCDATA_f2, GYRODATA_f2, fs);

%% Create subplots
% Create subplots for f1
figure;

% Accelerometer for f1
subplot(3, 2, 1);
plot(t_f1 - t0_f1, acc_f1(:, 1), 'b', 'LineWidth', 2);
title('Accelerometer X (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 3);
plot(t_f1 - t0_f1, acc_f1(:, 2), 'g', 'LineWidth', 2);
title('Accelerometer Y (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 5);
plot(t_f1 - t0_f1, acc_f1(:, 3), 'r', 'LineWidth', 2);
title('Accelerometer Z (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Gyroscope for f1
subplot(3, 2, 2);
plot(t_f1 - t0_f1, om_f1(:, 1), 'b', 'LineWidth', 2);
title('Gyroscope X (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 4);
plot(t_f1 - t0_f1, om_f1(:, 2), 'g', 'LineWidth', 2);
title('Gyroscope Y (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 6);
plot(t_f1 - t0_f1, om_f1(:, 3), 'r', 'LineWidth', 2);
title('Gyroscope Z (Phone)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

sgtitle('Phone (f1) - Accelerometer and Gyroscope');

% Create subplots for f2
figure;

% Accelerometer for f2
subplot(3, 2, 1);
plot(t_f2 - t0_f2, acc_f2(:, 1), 'b', 'LineWidth', 2);
title('Accelerometer X (Phone2)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 3);
plot(t_f2 - t0_f2, acc_f2(:, 2), 'g', 'LineWidth', 2);
title('Accelerometer Y (Phone2)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 5);
plot(t_f2 - t0_f2, acc_f2(:, 3), 'r', 'LineWidth', 2);
title('Accelerometer Z (Phone2)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Gyroscope for f2
subplot(3, 2, 2);
plot(t_f2 - t0_f2, om_f2(:, 1), 'b', 'LineWidth', 2);
title('Gyroscope X (Phone2)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 4);
plot(t_f2 - t0_f2, om_f2(:, 2), 'g', 'LineWidth', 2);
title('Gyroscope Y (Phone2)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 6);
plot(t_f2 - t0_f2, om_f2(:, 3), 'r', 'LineWidth', 2);
title('Gyroscope Z (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

sgtitle('Phone2 (f2) - Accelerometer and Gyroscope');

%% Compute FIN signals
[omFin_f1, accFin_f1, OMFIN_f1, ACCFIN_f1, f_f1] = fnComputeAndDisplayValues(acc_f1, om_f1, fs);
[omFin_f2, accFin_f2, OMFIN_f2, ACCFIN_f2, f_f2] = fnComputeAndDisplayValues(acc_f2, om_f2, fs);

%% Filtering

[omFilt_f1,accFilt_f1] = fnFilterData(accFin_f1,omFin_f1,fs,fco);
[omFilt_f2,accFilt_f2] = fnFilterData(accFin_f2,omFin_f2,fs,fco);

%% Rotation calculation
g0_f1 = mean(accFin_f1(12:70,:));
g0_f2 = mean(accFin_f1(12:70,:));

%% Vector g calculation

g_f1 =  g0_f1/norm(g0_f1); 
g_f2 =  g0_f2/norm(g0_f2);

%% Rotation for the minus angle in the reference system

[v_f1, deltaT_f1, phi_f1, R_f1, g_f1] = calculateValues(omFin_f1, t_f1, g_f1);
[v_f2, deltaT_f2, phi_f2, R_f2, g_f2] = calculateValues(omFin_f2, t_f2, g_f2);

%% Display and IMU calculations

[acc_lin_f1,om_corrected_f1] = fnAccFromIMU(om_f1,acc_f1,f_f1,ACCDATA_f1);
[acc_lin_f2, om_corrected_f2] = fnAccFromIMU(om_f2,acc_f2,f_f2,ACCDATA_f2);

%% izracun pospeskov v globalnem koordinatnem sistemu
%f1
for i = 1:length(om_corrected_f1)
    v_f1 = om_corrected_f1(i,:);
    deltaT_f1 = t_f1(i+1) - t_f1(i);
    phi_f1 = norm(v_f1)*deltaT_f1*180/pi;
    v_f1 = v_f1 / norm(v_f1);
    R_f1 = fnRotacijskaMatrika(phi,v_f1);
    acc_lin_f1(i+1,:) = (R_f1 * acc_lin_f1(i,:)')';
end

%f2
for i = 1:length(om_corrected_f2)
    v_f2 = om_corrected_f1(i,:);
    deltaT_f2 = t_f2(i+1) - t_f2(i);
    phi_f2 = norm(v_f2)*deltaT_f2*180/pi;
    v_f2 = v_f2 / norm(v_f2);
    R_f2 = fnRotacijskaMatrika(phi,v_f2);
    acc_lin_f2(i+1,:) = (R_f2 * acc_lin_f2(i,:)')';
end

%% izracun hitrosti v globalnem koordinatnem sistemu
velocity_f1 = acc_lin_f1 * deltaT_f1; % Speed for f1
velocity_f2 = acc_lin_f2 * deltaT_f2; % Speed for f2

%% izracun poti v globalnem koordinatnem sistemu
%upoštevaj prejšnje meritve
[position_f1,comulative_f1,leaky_f1] = fnGetPosition(velocity_f1,deltaT_f1,lambda);
[position_f2,comulative_f2,leaky_f2] = fnGetPosition(velocity_f2,deltaT_f2,lambda);

%% uporaba komplementarnega filtra
g_comp_f1 = fnGComplimentaryFilter(acc_lin_f1,om_corrected_f1,g0_f1,1/defaultSampling,lambda);
g_comp_f2 = fnGComplimentaryFilter(acc_lin_f2,om_corrected_f2,g0_f2,1/defaultSampling,lambda);


% Plot the orientation estimates for f1 dataset
figure;
subplot(2, 1, 1); % Create a subplot for f1
plot(time_f1, g_comp_f1(:, 1), 'r', 'LineWidth', 2); % Plot roll (or the first orientation component)
hold on;
plot(time_f1, g_comp_f1(:, 2), 'g', 'LineWidth', 2); % Plot pitch (or the second orientation component)
plot(time_f1, g_comp_f1(:, 3), 'b', 'LineWidth', 2); % Plot yaw (or the third orientation component)
title('Orientation Estimates for f1 Dataset');
xlabel('Time (s)');
ylabel('Orientation');
legend('Roll', 'Pitch', 'Yaw');
grid on;

% Plot the orientation estimates for f2 dataset
subplot(2, 1, 2); % Create a subplot for f2
plot(time_f2, g_comp_f2(:, 1), 'r', 'LineWidth', 2); % Plot roll (or the first orientation component)
hold on;
plot(time_f2, g_comp_f2(:, 2), 'g', 'LineWidth', 2); % Plot pitch (or the second orientation component)
plot(time_f2, g_comp_f2(:, 3), 'b', 'LineWidth', 2); % Plot yaw (or the third orientation component)
title('Orientation Estimates for f2 Dataset');
xlabel('Time (s)');
ylabel('Orientation');
legend('Roll', 'Pitch', 'Yaw');
grid on;

% Adjust subplot layout
subplot(2, 1, 1);
linkaxes;

% Adjust figure properties as needed
sgtitle('Orientation Estimates for f1 and f2 Datasets');

%% uporaba Kalmanovega filtra

