
%Created by tarmizi Adam.
%revisited on 28/2/15
%This function Ask user to select a wave file and plots its corresponding
% Wavelet Cepstral Coefficients (WCC)

% Input: Wave file( ".wav")
% Output: Wavelet Cepstral Coefficients (WCC)

[fileName,pathName] = uigetfile('.wav','Select wave file');
fileName = fullfile(pathName, fileName);

wObj = waveFile2obj(fileName)

epdParam=epdPrmSet(wObj.fs);
ep = epdByVolHod(wObj,epdParam, 0);
y2=wObj.signal(ep(1,1):ep(1,2));

yEmphasis = filter([1,-0.95],1,y2);
yFramed = buffer2(yEmphasis,256,128); % Frame the signal into chunks

for i=1:size(yFramed,2)
    yWindowed(:,i) = hamming(256).*yFramed(:,i);
    [C(:,i),L(:,i)]= wavedec(yWindowed(:,i),3,'db4');
    a3(:,i) = appcoef(C(:,i),L(:,i),'db4',3);
    d3(:,i) = detcoef(C(:,i),L(:,i),3);
    
    waveEnergy(:,i) = log(sum(abs(a3(:,i)   ).^2 ))
    waveEnergy2(:,i) = log(sum(abs(d3(:,i)   ).^2 ))
   
end

waveEnergy = waveEnergy(:)';
waveEnergy2 = waveEnergy2(:)';

waveletCepst = dct(waveEnergy);
waveletCepst2 = dct(waveEnergy2);

waveletCepst = waveletCepst(1,:);
waveletCepst2 = waveletCepst2(1,:);
Cepstrum = horzcat(waveletCepst,waveletCepst2);
plot(waveletCepst);

