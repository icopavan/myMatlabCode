waveFile = '0BF1S1T0.wav';
[y, fs, nbits] = wavread(waveFile);

epdParam=epdParamSet(fs);
ep = epdByVolHod(y, fs, nbits, epdParam, 0);
y=y(ep(1):ep(2));

yEmphasis = filter([1,-0.95],1,y); %pre-emphasis filtering

yFramed = buffer2(yEmphasis,256,128); % framing

for i=1:size(yFramed,2)
  yWindowed(:,i) = hamming(256).*yFramed(:,i);
  [C(:,i),L(:,i)]= wavedec(yWindowed(:,i),3,'db4');
  waveletCoef = appcoef(C(:,i),L(:,i),'db4',3);
  waveletCoef2(:,i) = detcoef(C(:,i),L(:,i),3);
  
  energyWaveletCoef = log(sum(abs(waveletCoef(:,i)).^2));
  energyWaveletCoef2(:,i) = log(abs(fft(waveletCoef2(:,i))));
  waveletCeps(:,i) = dct(energyWaveletCoef(:,i));
  waveletCeps2(:,i) = dct(energyWaveletCoef2(:,i));
  fftResult(:,i) = log(abs(fft(yWindowed(:,i))));
  realCeps(:,i) = dct(fftResult(:,i));
end






%waveletCoef = appcoef(C,L,'db4',3);
%waveletEnergy = abs(waveletCoef)/length(waveletCoef);
%logEnergy = log(waveletEnergy);
%waveletCepstrum = dct(eps+logEnergy);

%fftEnergy = log(abs(fft(frame2)));
%fftceps = dct(fftEnergy);


