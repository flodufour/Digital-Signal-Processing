clear; close all; clc;

%% Get script folder (src)
scriptPath = fileparts(mfilename('fullpath'));

%% Go to project root

basePath = fullfile(scriptPath);

figPath   = fullfile(basePath,'..','figures');
audioPath   = fullfile(basePath,'..','audios');


if ~exist(figPath,'dir')
    mkdir(figPath);
end


%% Load signals
[bonjour, Fs1] = audioread(fullfile(audioPath,'bonjour-bruite.wav'));
[mozart,  Fs2] = audioread(fullfile(audioPath,'mozart-bruite.wav'));

% Convert to mono if stereo
bonjour = mean(bonjour,2);
mozart  = mean(mozart,2);

%% BONJOUR

t = (0:length(bonjour)-1)/Fs1;

fig1 = figure;
plot(t, bonjour);
title('Bonjour - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

exportgraphics(fig1, fullfile(figPath,'bonjour_time.png'), 'Resolution', 300);

N = length(bonjour);

%% Spectrum before filtering
X = fft(bonjour);
X_mag = abs(X)/N;
f = (-N/2:N/2-1)*(Fs1/N);

fig2 = figure;
plot(f, fftshift(X_mag));
title('Bonjour - Frequency Spectrum (Before)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-1000 1000]);

exportgraphics(fig2, fullfile(figPath,'bonjour_spectrum_before.png'), 'Resolution', 300);

% Observation:
% The frequency spectrum shows a strong narrow peak around 500 Hz,
% indicating a dominant sinusoidal interference in the signal between 497–503 Hz.
% This component is not part of the speech content and must be removed.
% Therefore, a narrow band-stop filter around 495–505 Hz
% will be applied to attenuate this unwanted frequency while preserving
% the rest of the speech signal.

%% FILTER DESIGN (495–505 Hz)
f_low = 495;
f_high = 505;

Wn = [f_low f_high] / (Fs1/2);

order = 4;  

[b,a] = butter(order, Wn, 'stop');

bonjour_filt = filtfilt(b, a, bonjour);

%% Spectrum after filtering
Xf = fft(bonjour_filt);
Xf_mag = abs(Xf)/N;

fig3 = figure;
plot(f, fftshift(Xf_mag));
title('Bonjour - Frequency Spectrum (After Filtering)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;

exportgraphics(fig3, fullfile(figPath,'bonjour_spectrum_after.png'), 'Resolution', 300);

xlim([-1000 1000]);

audiowrite(fullfile(audioPath,'bonjour_filtre.wav'), bonjour_filt, Fs1);

% Audio is now cleaned

%% MOZART

t = (0:length(mozart)-1)/Fs1;

fig4 = figure;
plot(t, mozart);
title('Mozart - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

exportgraphics(fig4, fullfile(figPath,'mozart_time.png'), 'Resolution', 300);

N = length(mozart);

%% Spectrum before filtering
X = fft(mozart);
X_mag = abs(X)/N;
f = (-N/2:N/2-1)*(Fs1/N);

fig5 = figure;
plot(f, fftshift(X_mag));
title('Mozart - Frequency Spectrum (Before)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-1000 1000]);

exportgraphics(fig5, fullfile(figPath,'mozart_spectrum_before.png'), 'Resolution', 300);

% Observation:
% A strong narrow peak appears around 698 Hz,
% indicating a tonal interference in the signal.

%% FILTER DESIGN (695–700 Hz)
f_low = 680;
f_high = 710;

Wn = [f_low f_high] / (Fs1/2);

order = 4;

[b,a] = butter(order, Wn, 'stop');

mozart_filt = filtfilt(b, a, mozart);

%% Spectrum after filtering
Xf = fft(mozart_filt);
Xf_mag = abs(Xf)/N;

fig6 = figure;
plot(f, fftshift(Xf_mag));
title('Mozart - Frequency Spectrum (After Filtering)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;

xlim([-3000 3000]);

exportgraphics(fig6, fullfile(figPath,'mozart_spectrum_after.png'), 'Resolution', 300);


audiowrite(fullfile(audioPath,'mozart_filtre.wav'), mozart_filt, Fs1);


% Observation:
% Ameliation in soud quality but still noisy.
% An other strong narrow peak appears around 2830 Hz,
% indicating a tonal interference in the signal.


%% SECOND FILTER DESIGN (2825–2835 Hz)
f_low = 2825;
f_high = 2835;

Wn = [f_low f_high] / (Fs1/2);

order = 4;

[b,a] = butter(order, Wn, 'stop');

mozart_filt_2 = filtfilt(b, a, mozart_filt);

%% Spectrum after Second filtering
Xf = fft(mozart_filt_2);
Xf_mag = abs(Xf)/N;

fig7 = figure;
plot(f, fftshift(Xf_mag));
title('Mozart - Frequency Spectrum (After Second Filtering)');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
grid on;

xlim([-1000 1000]);

exportgraphics(fig7, fullfile(figPath,'mozart_spectrum_after_2.png'), 'Resolution', 300);

audiowrite(fullfile(audioPath,'mozart_filtre_2.wav'), mozart_filt_2, Fs1);

% Audio is now cleaned.

