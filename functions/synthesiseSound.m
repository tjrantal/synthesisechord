%Synthesise signals with sine waves based on fundamental frequency, harmonic amplitude coefficients, and amplitude envelope. The maximum amplitude of the synthesised signal is normalised to 1
%@param f0 fundamental frequency
%@param coeffs amplitude coefficients to apply on the harmonics of the fundamental frequency (1 = f0 amplitude)
%@param envelope amplitude envelope to apply, the length of the envelope defines the duration of the synthesised signal as well.
%@param sFreq sample rate
%@returns the synthesised signal.

function synthesised = synthesiseSound(f0,coeffs,envelope,sFreq)
	synthesised = zeros(1,length(envelope));
	w = 2*pi;
	t = ([1:length(envelope)]-1)./sFreq;
	for h = 1:length(coeffs)
		synthesised = synthesised+coeffs(h)*sin(2*pi*h*f0*t);
	end
	synthesised = synthesised.*envelope;
	synthesised = synthesised./max(abs(synthesised));
