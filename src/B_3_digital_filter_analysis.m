clear; close all; clc;

%% Paths
scriptPath = fileparts(mfilename('fullpath'));
basePath = fullfile(scriptPath,'..');
figPath = fullfile(basePath,'figures');

if ~exist(figPath,'dir')
    mkdir(figPath);
end

%% Transfer function H(z)

b = [1 -1];
a = [1 20 75];

%% a) Pole-zero map
sys = tf(b,a,1);

fig1 = figure;
pzmap(sys);
title('Pole-Zero Map of H(z)');
grid on;

exportgraphics(fig1, fullfile(figPath,'pzmap_2.png'), 'Resolution', 300);

%% Stability check
p = roots(a);
disp('Poles:');
disp(p);

%% b) Impulse response
n = 0:10;
h = impz(b,a,length(n));

fig2 = figure;
stem(n,h,'filled');
title('Impulse Response h[n]');
xlabel('n'); ylabel('h[n]');
grid on;

exportgraphics(fig2, fullfile(figPath,'impulse_2.png'), 'Resolution', 300);

%% c) Frequency response
fig3 = figure;
freqz(b,a,1024);
title('Frequency Response H(e^{j\omega})');

exportgraphics(fig3, fullfile(figPath,'freq_2.png'), 'Resolution', 300);

%% Stability decision
if all(abs(p) < 1)
    disp('System is STABLE');
else
    disp('System is UNSTABLE');
end