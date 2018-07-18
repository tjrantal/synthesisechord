%Creates exponentially decreasing harmonic amplitude coefficients for sound synthesis
%@param harmonics the number of harmonic coefficients to create
%@param highestCoeff the coefficient of the highest harmonic
%@returns the harmonic amplitude coefficients
function coeffs = harmonicCoeffs(harmonics,highestCoeff)
	%Create exponential decay
	%https://en.wikipedia.org/wiki/Exponential_decay
	t = [1:harmonics]-1;
	lambda = -(harmonics(end))/log(highestCoeff);
	coeffs = exp(-t/lambda);

