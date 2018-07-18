fclose all;
close all;
clear all;
clc;
addpath('functions');
%info = audioinfo('rsc/piano_a440.ogg')
[soundSample,sFreq] = audioread('rsc/piano_a440.ogg');
epoch = [0.8 6];	%Chosen manually

t = ([1:length(soundSample)]-1)./sFreq;
chosen = find(t >= epoch(1) & t<= epoch(2));
[coeffs, freq] = getFFTCoeffs(soundSample(chosen),sFreq);

if 0
	fh = figure('position',[0,30,1000,500]);
	ah  = [];
	subplot(2,1,1)
	plot(t(chosen),soundSample(chosen),'linewidth',3);
	title('Signal in')
	ah(1) = gca();


	subplot(2,1,2)
	plot(freq,abs(coeffs),'linewidth',3);
	hold on;
	set(gca,'xlim',[0 4000]);
	title('Amplitude spectrum');
	ah(2) = gca();
end
%Visual inspection revealed 438.5 as f0
%Manually selected coeffs
harmonics = [438.37 877.9 1318.6 1761.4 2206.9 2656.15];
hfAdj = harmonics./harmonics(1);

%Debugging
if 0
	f0 = 439;
	for f = 1:10
		plot(f0*f.*[1 1],[-0.001 0],'r','linewidth',5);
	end
	set(ah(2),'ylim',[-0.001 0.003]);
end

%Extract sine and cosine coefficients
harmonicCoeffs = zeros(2,length(harmonics));
tolerance = 0.5;

for h = 1:length(harmonics)
	indices = find(freq > harmonics(h)-tolerance & freq < harmonics(h)+tolerance);
	tempCoeffs = coeffs(indices);
	if 0
		
		tempAmps = abs(coeffs(indices));
		[ignore ind] = max(tempAmps);
		harmonicCoeffs(1,h) =real(tempCoeffs(ind));
		harmonicCoeffs(2,h) =imag(tempCoeffs(ind));
	else
		harmonicCoeffs(1,h) =sum(real(tempCoeffs));
		harmonicCoeffs(2,h) =sum(imag(tempCoeffs));
	end
	
end

%DEBUGGING
%tempAmps = sqrt(sum(harmonicCoeffs.^2));

%RecoSignal
recosig = recoSignal(440,harmonicCoeffs,hfAdj,sFreq,2);
save('-ascii','rsc/harmonicCoeffs.txt','harmonicCoeffs');
save('-ascii','rsc/hfAdj.txt','hfAdj');

envelope = amplitudeEnvelope(2,0.2,0.05,1.65,0.1,sFreq);
envSig = recosig.*envelope;
envSig = envSig./max(abs(envSig));
audiowrite('synthA.ogg',envSig',sFreq);
%keyboard;
if 0
	figure
	plot(([1:length(envSig)]-1)./sFreq,envSig,'linewidth',3);
	set(gca,'xlim',[0.2 0.3]);
	keyboard;
end




