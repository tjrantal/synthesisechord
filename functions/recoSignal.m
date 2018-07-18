%Reconstruct a signal based on fundamental frequency, relative harmonic frequencies, and corresponding fft coefficients.
%@param f0 fundamental frequency
%@param harmonicCoeffs fft coefficients 1,: = cosine coefficients (real part), 2,: = sine coefficients (imaginary part)
%@param hfAdj relative harmonic frequencies
%@param sFreq sample rate
%@param duration the duration of the synthesised signal in seconds
%@param [envelope] amplitude envelope to apply, triggers normalising the maximum amplitude to one as well
%@returns the reconstructed (synthesised) signal.

function recosig = recoSignal(f0,harmonicCoeffs,hfAdj,sFreq,duration,envelope)
	sigLength = floor(sFreq*duration);
	recosig = zeros(1,sigLength);
	t = ([1:sigLength]-1)./sFreq;
	w = 2*pi;
	for h = 1:size(harmonicCoeffs,2)
		recosig = recosig+cos(w*f0*hfAdj(h)*t)*harmonicCoeffs(1,h)-sin(w*f0*hfAdj(h)*t)*harmonicCoeffs(2,h);
		%keyboard;
	end
	
	if exist('envelope','var')
		%Apply the envelope and normalise amplitude to 1
		recosig = recosig.*envelope;
		recosig = recosig./max(abs(recosig));
	end	

