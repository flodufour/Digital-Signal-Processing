clear; close all; clc;

%% Paths
scriptPath = fileparts(mfilename('fullpath'));
basePath = fullfile(scriptPath,'..');

figPath = fullfile(basePath,'figures');

if ~exist(figPath,'dir')
    mkdir(figPath);
end

%  y[n] = 0.5 y[n-1] + x[n]

b = [1];        % numerator
a = [1 -0.5];   % denominator

%% Impulse response h[n]

n = 0:30;
h = impz(b,a,length(n));

fig1 = figure;
stem(n,h,'filled');
title('Impulse Response h[n]');
xlabel('n');
ylabel('h[n]');
grid on;

exportgraphics(fig1, fullfile(figPath,'impulse_response.png'), 'Resolution', 300);

%% Transfer function H(z)
sys = tf(b,a,1);   % sampling time = 1

disp('Transfer Function H(z):');
sys;

%% Pole-zero map
fig2 = figure;
pzmap(sys);
title('Pole-Zero Map');
grid on;

exportgraphics(fig2, fullfile(figPath,'pzmap.png'), 'Resolution', 300);

%% Frequency response

fig3 = figure;
freqz(b,a,1024);
title('Frequency Response H(e^{j\omega})');

exportgraphics(fig3, fullfile(figPath,'freq_response.png'), 'Resolution', 300);

%% Output signal for input x[n]

n = 0:10;

x = sin(0.8*pi*n) + 0.5*randn(size(n));

y = filter(b,a,x);

fig4 = figure;

stem(n,x,'filled');
hold on;
stem(n,y,'filled');

legend('Input x[n]','Output y[n]');
title('System Input/Output');
xlabel('n'); ylabel('Amplitude');
grid on;

exportgraphics(gcf, fullfile(figPath,'input_output.png'), 'Resolution', 300);
%% Stability & causality analysis

% Poles
p = roots(a);

disp('Poles:');
disp(p);

if all(abs(p) < 1)
    disp('System is STABLE');
else
    disp('System is UNSTABLE');
end

disp('System is causal (depends only on past values)');