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
noteDuration = 0.2;
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


%Synthesise sound here
songNotes = {'FSharp','E','FSharp','G','FSharp','E','FSharp','D','E','E','FSharp'};
octaves = ones(1,length(songNotes)).*4;
noteDurations = [2,2,2,6,2,2,2,3,1,2,4];

songAudio = [];
for s = 1:length(songNotes)
	envelope = amplitudeEnvelope(noteDuration*noteDurations(s),0.8,0.05,0.1,0.05,sFreq);
	songAudio = [songAudio, recoSignal(notes.(songNotes{s})(octaves(s)),harmonicCoeffs,hfAdj,sFreq,noteDuration*noteDurations(s),envelope)];
end


audiowrite('synthSong.ogg',songAudio',sFreq);


