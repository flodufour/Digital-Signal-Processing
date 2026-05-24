clear; close all; clc;

%% Get script folder (src)
scriptPath = fileparts(mfilename('fullpath'));

%% Go to project root
figPath   = fullfile(scriptPath,'..','figures');

if ~exist(figPath,'dir')
    mkdir(figPath);
end

%% Time index
n = -10:10;

%% x1[n] = 0.3 δ[n-2] - 2 δ[n+1]
x1 = zeros(size(n));
x1(n == 2) = 0.3;
x1(n == -1) = x1(n == -1) - 2;

%% x2[n] = 1 for n in [0,10]
x2 = zeros(size(n));
x2(n >= 0 & n <= 10) = 1;

%% Plot using subplot
fig = figure;

subplot(2,1,1);
stem(n, x1, 'filled');
title('x_1[n] = 0.3\delta[n-2] - 2\delta[n+1]');
xlabel('n');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(n, x2, 'filled');
title('x_2[n] = 1 for 0 \leq n \leq 10');
xlabel('n');
ylabel('Amplitude');
grid on;

%% Save figure
exportgraphics(fig, fullfile(figPath,'b1_signals.png'), 'Resolution', 300);