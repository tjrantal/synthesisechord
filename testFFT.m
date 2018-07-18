fclose all;
close all;
clear all;
clc;

fs = 44100;
t = 0:1/fs:10;
w = 2*pi;
f0 = 552.3;
signal = sin(w*f0*t);
figure
plot(t,signal,'linewidth',3);
set(gca,'ylim',[-1.1 1.1],'xlim',[0.2 0.3]);
[coeffs,freq] = getFFTCoeffs(signal,fs);
figure
plot(freq,abs(coeffs),'linewidth',3);
[ign ind] = max(abs(coeffs));
titleString = sprintf('Max freq %.1f',freq(ind));
title(titleString);

disp(titleString);
