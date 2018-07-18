%	This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%	N.B.  the above text was copied from http://www.gnu.org/licenses/gpl.html
%	unmodified. I have not attached a copy of the GNU license to the source...
%
%    Copyright (C) 2018 Timo Rantalainen

fclose all;
close all;
clear all;
clc;

addpath('functions');



%Constants
sFreq = 44100;
harmonics = 20;
noteDuration = 2;
delayDuration = 0.2;
load('-ascii','rsc/harmonicCoeffs.txt');
load('-ascii','rsc/hfAdj.txt');

%Create notes here http://www.phy.mtu.edu/~suits/NoteFreqCalcs.html
octaves = 6;	%Create 6 octaves of notes
noteNames = {'A','ASharp','B','C','CSharp','D','DSharp','E','F','FSharp','G','GSharp'};
baseFreq = 27.5;
noteStruct = struct();
notePows = [1:octaves*length(noteNames)]-1;	
a = 2^(1/12);
noteFreqs =  baseFreq*(a.^notePows);
noteFreqs = reshape(noteFreqs,[length(noteNames), octaves]); 
%Pop the notes into a struct to make it easier to handle
notes = struct();	
for n = 1:length(noteNames)
	notes.(noteNames{n}) = noteFreqs(n,:);
end

envelope = amplitudeEnvelope(noteDuration,0.8,0.05,0.35,0.1,sFreq);

%Synthesise sound here
note1 = recoSignal(notes.C(5),harmonicCoeffs,hfAdj,sFreq,noteDuration,envelope);
note2 = recoSignal(notes.E(5),harmonicCoeffs,hfAdj,sFreq,noteDuration,envelope);
note3 = recoSignal(notes.G(5),harmonicCoeffs,hfAdj,sFreq,noteDuration,envelope);

%Add delays...
delayPadding = zeros(1,int32(sFreq*delayDuration));
note1 = [note1 delayPadding delayPadding];
note2 = [delayPadding note2 delayPadding];
note3 = [delayPadding delayPadding note3];

chord = note1 + note2 + note3;
chord = chord./max(abs(chord));

audiowrite('synthChord.ogg',chord',sFreq);


