%
%    Copyright 2015 Douglas Bellon Rocha
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: getDataFromFft
% Description:
%     Reads wav file sent by parameter and returns
% an array of 4 values respectively:
% 1) Average Frequency 
% 2) Average Amplitude
% 3) Frequency Standard Deviation
% 4) Amplitude Standard Deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function retval = getDataFromFft(filePath)
  [y, Fs, bits] = wavread(filePath);

  % Prepare time data for plot
  Nsamps = length(y);
  t = (1/Fs)*(1:Nsamps);

  %Do Fourier Transform
  %Retain Magnitude
  y_fft = abs(fft(y));

  %Discard half of points
  y_fft = y_fft(1:Nsamps / 2);

  %Prepare freq data for plot
  f = Fs * (0:Nsamps / 2 - 1) / Nsamps;
  ffilter = arrayfun(@le, f, 1200);
  y_fft = y_fft .* ffilter;

  mediaPonderada = 0;
  somaTotal = 0;
  fPonderado = 1:length(y_fft);

  for i=1:length(y_fft),
    somaTotal = somaTotal + y_fft(i);
    mediaPonderada = mediaPonderada + (y_fft(i) * f(i));
    fPonderada(i) = y_fft(i) * f(i);
  endfor

  retval = 1:4;
  retval(1) = mediaPonderada / somaTotal;
  retval(2) = sum(y_fft) / sum(ffilter);
  retval(3) = std(fPonderada);
  retval(4) = std(y_fft);
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: plotDataFromFile
% Description:
%     Calls getDataFromFile and returns its value
% and afterwards, plots data of the fft audio file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotDataFromFft(filePath)
  [y, Fs, bits] = wavread(filePath);

  % Prepare time data for plot
  Nsamps = length(y);
  t = (1/Fs)*(1:Nsamps);

  %Do Fourier Transform
  %Retain Magnitude
  y_fft = abs(fft(y));

  %Discard half of points
  y_fft = y_fft(1:Nsamps / 2);

  %Prepare freq data for plot
  f = Fs * (0:Nsamps / 2 - 1) / Nsamps;
  
  %Plot Sound File in the Frequency Domain
  plot(f, y_fft);
  xlim([0 1200]);
  xlabel('Frequencia (Hz)');
  ylabel('Amplitude');
  title('Transformada de Fourier');
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: plotDataFromWavFile
% Description:
%     Reads Wav file and plots it on the time 
% domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotDataFromWavFile(filePath)
  [y, Fs, bits] = wavread(filePath);

  %Prepare time data for plot
  Nsamps = length(y);
  t = (1/Fs) * (1:Nsamps);

  %Plot sound file in time domain
  plot(t, y);
  xlabel('Tempo (s)');
  ylabel('Amplitude');
  title('Domínio do Tempo');
endfunction
