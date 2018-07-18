%Creates an attack, decay, sustain, release amplitude envelope for sound synthesis
%@param duration duration of the synthesised sound in seconds
%@param sustainCoeff the coefficient of sustain amplitude [0 to 1]
%@param attackDuration duration of the attack phase
%@param decayDuration duration of the decay phase
%@param releaseDuration duration of the release phase
%@param sFreq sample rate
%@returns the amplitude envelope
function envelope = amplitudeEnvelope(duration,sustainCoeff,attackDuration,decayDuration,releaseDuration,sFreq)
	envelopeLength = floor(duration*sFreq);
	attackPhaseLength = floor(attackDuration*sFreq);
	decayPhaseLength = floor(decayDuration*sFreq);
	releasePhaseLength = floor(releaseDuration*sFreq);
	sustainLength = envelopeLength-attackPhaseLength-decayPhaseLength-releasePhaseLength;

	%Create the amplitude envelope components
	attack = ([1:attackPhaseLength]-1)./(attackPhaseLength-1);	%From zero to one
	sustain = ones(1,sustainLength).*sustainCoeff;
	release = flip(([1:releasePhaseLength]-1)./(releasePhaseLength-1)).*sustainCoeff;	%From zero to one
	
	%Create exponential decay to sustain level
	%https://en.wikipedia.org/wiki/Exponential_decay
	t = [1:decayPhaseLength];
	lambda = -decayPhaseLength/log(sustainCoeff);
	decay = exp(-t/lambda);
	
	%Return the amplitude envelope
	envelope = [attack, decay, sustain, release];
