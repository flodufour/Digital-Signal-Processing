clear; close all; clc;

%% Get script folder (src)
scriptPath = fileparts(mfilename('fullpath'));

%% Go to project root
figPath   = fullfile(scriptPath,'..','figures');

if ~exist(figPath,'dir')
    mkdir(figPath);
end

%% Parameters
Fe = 512;                 % Sampling frequency
t = 0:1/Fe:1;            % Time vector

f1 = 5;
f2 = 20;                 % Frequency to remove
f3 = 35;

%% Signal
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + sin(2*pi*f3*t);

%% Time domain plot
fig1 = figure;
plot(t, x);
title('x(t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

exportgraphics(fig1, fullfile(figPath,'time_signal.png'), 'Resolution', 300);

%% Frequency domain
N = length(x);
f = (-N/2:N/2-1)*(Fe/N);

X = fftshift(abs(fft(x)));

fig2 = figure;
plot(f, X);
title('Spectrum of x(t)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;

exportgraphics(fig2, fullfile(figPath,'spectrum_signal.png'), 'Resolution', 300);

%% Band-stop filter (remove 20 Hz)
order = 4;
Wn = [18 22]/(Fe/2);

[b, a] = butter(order, Wn, 'stop');

%% Filtering
x_filt = filter(b, a, x);

%% Spectrum after filtering
Xf = fftshift(abs(fft(x_filt)));

fig3 = figure;
plot(f, Xf);
title('Filtered spectrum');
xlabel('Frequency (Hz)');
ylabel('|X_{filtered}(f)|');
grid on;

exportgraphics(fig3, fullfile(figPath,'filtered_spectrum.png'), 'Resolution', 300);