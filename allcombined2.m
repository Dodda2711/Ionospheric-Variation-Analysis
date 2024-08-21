clear; clc;  % Clear workspace and command window

%% Set up the Import Options and import the GNSS data
gnss_opts = delimitedTextImportOptions("NumVariables", 10);
gnss_opts.DataLines = [6, Inf];
gnss_opts.Delimiter = ["\t", " "];
gnss_opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
gnss_opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
gnss_opts.ExtraColumnsRule = "ignore";
gnss_opts.EmptyLineRule = "read";
gnss_opts.ConsecutiveDelimitersRule = "join";

% Paths for GNSS data files
gnss_files = {
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\EgSA GNSS\Day.26\EgSA147-2024-05-26.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\EgSA GNSS\Day.27\EgSA148-2024-05-27.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\EgSA GNSS\Day.28\EgSA149-2024-05-28.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\EgSA GNSS\Day.29\EgSA150-2024-05-29.Cmn'
};

% Initialize matrix for GNSS data
gnss_allData = [];

for i = 1:numel(gnss_files)
    data = readmatrix(gnss_files{i}, gnss_opts);
    gnss_allData = [gnss_allData; data];
end

% Convert Modified Julian Date to Julian Date and then to datetime for GNSS
gnss_MJdatet = gnss_allData(:, 1);
gnss_JD = gnss_MJdatet + 2400000.5;
gnss_time_ground = datetime(gnss_JD, 'convertfrom', 'juliandate', 'Format', 'yyyy-MM-dd HH:mm:ss');
gnss_Vtec = gnss_allData(:, 9);
gnss_Lat = gnss_allData(:, 6);

%% Set up the Import Options and import the low-cost data
lowcost_opts = delimitedTextImportOptions("NumVariables", 10);
lowcost_opts.DataLines = [6, Inf];
lowcost_opts.Delimiter = ["\t", " "];
lowcost_opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10"];
lowcost_opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
lowcost_opts.ExtraColumnsRule = "ignore";
lowcost_opts.EmptyLineRule = "read";
lowcost_opts.ConsecutiveDelimitersRule = "join";

% Paths for low-cost data files
lowcost_files = {
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\Low-Cost GNSS\147\CARO147-2024-05-26.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\Low-Cost GNSS\148\CARO148-2024-05-27.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\Low-Cost GNSS\149\CARO149-2024-05-28.Cmn',
    'F:\MathWorks_MATLAB_R2023a_v9.14.0.2206163\GNSS\Low-Cost GNSS\150\CARO150-2024-05-29.Cmn'
};

% Initialize matrix for low-cost data
lowcost_allData = [];

for i = 1:numel(lowcost_files)
    data = readmatrix(lowcost_files{i}, lowcost_opts);
    lowcost_allData = [lowcost_allData; data];
end

% Convert Modified Julian Date to Julian Date and then to datetime for low-cost
lowcost_MJdatet = lowcost_allData(:, 1);
lowcost_JD = lowcost_MJdatet + 2400000.5;
lowcost_time_ground = datetime(lowcost_JD, 'convertfrom', 'juliandate', 'Format', 'yyyy-MM-dd HH:mm:ss');
lowcost_Vtec = lowcost_allData(:, 9);
lowcost_Lat = lowcost_allData(:, 6);

%% Create figure with subplots
figure;

% Subplot 1: VTEC over time for GNSS data
subplot(3, 2, 1);
plot(gnss_time_ground, gnss_Vtec, 'b');
xlabel('Time');
ylabel('VTEC');
title('GNSS VTEC Over Time');
grid on;

% Subplot 2: VTEC over time for low-cost data
subplot(3, 2, 2);
plot(lowcost_time_ground, lowcost_Vtec, 'r');
xlabel('Time');
ylabel('VTEC');
title('Low-Cost VTEC Over Time');
grid on;

% Subplot 3: Scatter plot and average VTEC for GNSS
subplot(3, 2, 3);
scatter(gnss_time_ground, gnss_Vtec, 10, gnss_Lat, 'filled');
colormap(jet);
clim([20 40]);
cbar = colorbar;  % Create the colorbar
cbar.Label.String = 'Latitude';  % Set the label
xlabel('Time');
ylabel('VTEC');
title('GNSS VTEC with Latitude Color');
hold on;
[gnss_unique_times, ~, gnss_idx] = unique(gnss_time_ground);
gnss_average_Vtec = accumarray(gnss_idx, gnss_Vtec, [], @mean);
plot(gnss_unique_times, gnss_average_Vtec, 'k-', 'LineWidth', 1.5);
legend('VTEC', 'Average VTEC');
hold off;

% Subplot 4: Scatter plot and average VTEC for low-cost
subplot(3, 2, 4);
scatter(lowcost_time_ground, lowcost_Vtec, 10, lowcost_Lat, 'filled');
colormap(jet);
clim([20 40]);
cbar = colorbar;  % Create the colorbar
cbar.Label.String = 'Latitude';  % Set the label
xlabel('Time');
ylabel('VTEC');
title('Low-Cost VTEC with Latitude Color');
hold on;
[lowcost_unique_times, ~, lowcost_idx] = unique(lowcost_time_ground);
lowcost_average_Vtec = accumarray(lowcost_idx, lowcost_Vtec, [], @mean);
plot(lowcost_unique_times, lowcost_average_Vtec, 'k-', 'LineWidth', 1.5);
legend('VTEC', 'Average VTEC');
hold off;


% Subplot 5: Overlay average VTEC for GNSS and low-cost data
subplot(3, 2, 5);
plot(gnss_unique_times, gnss_average_Vtec, 'b-', 'LineWidth', 1.5);
hold on;
plot(lowcost_unique_times, lowcost_average_Vtec, 'r-', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Average VTEC');
title('Average VTEC Comparison');
legend('GNSS Average VTEC', 'Low-Cost Average VTEC');
grid on;
hold off;

% Subplot 6: Smooth average VTEC for GNSS and low-cost data
subplot(3, 2, 6);
gnss_smoothed_Vtec = movmean(gnss_average_Vtec, 10);
lowcost_smoothed_Vtec = movmean(lowcost_average_Vtec, 10);
plot(gnss_unique_times, gnss_smoothed_Vtec, 'b-', 'LineWidth', 1.5);
hold on;
plot(lowcost_unique_times, lowcost_smoothed_Vtec, 'r-', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Smoothed Average VTEC');
title('Smoothed Average VTEC Comparison');
legend('GNSS Smoothed VTEC', 'Low-Cost Smoothed VTEC');
grid on;
hold off;
