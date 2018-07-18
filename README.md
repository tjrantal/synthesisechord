A project to synthesise reasonably pleasant sound. Written by Timo Rantalainen tjrantal at gmail dot com 2018, released into the public domain.

Tried synthesising sound with sine waves (testChord.m), which did not produce a pleasant sound.

The second attempt was to record my piano A5 note (should be 440 Hz looked to be about 438 Hz on my piano) with my smartphone (recording in rsc/piano_a440.ogg, converted to ogg format with ffmpeg [octave did not support mp3 by default..]). Extracted fundamental frequency and the first five harmonics fourier coefficients manually from this recording (pianoCoeffs.m -> created the text files in rsc/ folder with the fourier coefficients, and relative harmonic frequencies) and finally synthetised a chord with synthesiseChord.m (creates synthChord.ogg). The resulting sound is quite old-school (1980s) cheap keyboard synthesiser-like but that will have to do for my needs.








