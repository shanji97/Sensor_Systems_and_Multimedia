%f1 = phone (Pixel 4a 5G), f2 = phone (Galaxy A53 G).
app = 'phyphox' % Options: "phyphox", "stock" (as by SSM meausurements).
defaultSampling = 500 % Hz
%Distance = 40.3cm/tile 23 tiles in one direction 

%Load in the data (need to measure again because I lost them)
accFileName_f1     = "f1_accel.csv";
accFileName_f2     = "f2_accel.csv";

gyroFileName_f1     = "f1_gyro.csv";
gyroFileName_f2     = "f2_gyro.csv";

fs = (defaultSampling * 2) + 1;

%% Import IMU signals from f1 and f2 files and convert it to our notation.
[ACCDATA_f1, GYRODATA_f1]         = fnConvertFormats(gyroFileName_f1,accFileName_f1,app,defaultSampling);
[acc_f1, om_f1, t_f1, t0_f1] = fnSyncAccOmMW(ACCDATA_f1, GYRODATA_f1, fs);

[ACCDATA_f2, GYRODATA_f2]         = fnConvertFormats(gyroFileName_f2,accFileName_f2,app,defaultSampling);
[acc_f2, om_f2, t_f2, t0_f2] = fnSyncAccOmMW(ACCDATA_f1, GYRODATA_f1, fs);

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
title('Accelerometer X (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 3);
plot(t_f2 - t0_f2, acc_f2(:, 2), 'g', 'LineWidth', 2);
title('Accelerometer Y (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 5);
plot(t_f2 - t0_f2, acc_f2(:, 3), 'r', 'LineWidth', 2);
title('Accelerometer Z (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Gyroscope for f2
subplot(3, 2, 2);
plot(t_f2 - t0_f2, om_f2(:, 1), 'b', 'LineWidth', 2);
title('Gyroscope X (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 4);
plot(t_f2 - t0_f2, om_f2(:, 2), 'g', 'LineWidth', 2);
title('Gyroscope Y (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 2, 6);
plot(t_f2 - t0_f2, om_f2(:, 3), 'r', 'LineWidth', 2);
title('Gyroscope Z (Tablet)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

sgtitle('Tablet (f2) - Accelerometer and Gyroscope');

%% Compute FIN signals
[omFin_f1, accFin_f1, OMFIN_f1, ACCFIN_f1, f_f1] = computeAndDisplayValues(acc_f1, om_f1, fs);
[omFin_f2, accFin_f2, OMFIN_f2, ACCFIN_f2, f_f2] = computeAndDisplayValues(acc_f2, om_f2, fs);

%% filtriranje
fco = 2000;

[omFilt_f1,accFilt_f1] = filterData(accFin_f1,omFin_f1,fs,fco);
[omFilt_f2,accFilt_f2] = filterData(accFin_f2,omFin_f2,fs,fco);

%% izracun rotacije
g0_f1 = mean(accFin_f1(12:70,:));
g0_f2 = mean(accFin_f1(12:70,:));

%% izracun rotacije vektorja g

g_f1 =  g0_f1/norm(g0_f1); 
g_f2 =  g0_f2/norm(g0_f2);

%% rotacija za minus kot v referencnem sistemu

[v_f1, deltaT_f1, phi_f1, R_f1, g_f1] = calculateValues(omFin_f1, t_f1, g_f1);
[v_f2, deltaT_f2, phi_f2, R_f2, g_f2] = calculateValues(omFin_f2, t_f2, g_f2);

%% Display and IMU calculations

acc_lin_f1 = accFromIMU(om_f1,acc_f1);
acc_lin_f2 = accFromIMU(om_f2,acc_f2);
%%deltaN = ;

%% izracun pospeskov iz IMU


%% izracun pospeskov v globalnem koordinatnem sistemu
%% podobna for zanka

%% izracun hitrosti v globalnem koordinatnem sistemu

%% izracun poti v globalnem koordinatnem sistemu

%% uporaba komplementarnega filtra

%% uporaba Kalmanovega filtra