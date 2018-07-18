%A function to get hann-windowed fft-coefficients and corresponding frequencies
%@param signalIn the signal to transform
%@param sFreq the sample rate of the signal
%@returns coeffs, freq, the coefficients and frequencies, respectively
function [coeffs, freq] = getFFTCoeffs(signalIn,sFreq)
	%Apply hann windowing
	tempHann = hanning(length(signalIn));
	if size(tempHann,1) ~= size(signalIn,1)
		tempHann = tempHann';
	end
	hannWindowed = signalIn.*tempHann;
	%Double the signal length by appending zeroes
	if size(hannWindowed,1) > size(hannWindowed,2)
		hannWindowed = hannWindowed';
	end
	appended = [hannWindowed zeros(1,length(hannWindowed))];
	fftSignal = fft(appended);
	
	%Normalise the coefficients
	fftSignal= fftSignal./(length(fftSignal)/2+1);
   fftSignal(1) = fftSignal(1)/2;
   
   %Create the frequency bins corresponding to the coefficients
   freq = linspace(0,sFreq,length(appended));
   
   %Return only the first half of the coefficients
   freq = freq(1:length(signalIn));
   coeffs = fftSignal(1:length(freq));
