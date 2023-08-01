clc
clear
close all
tic
%% 1 生成调频信号：但当前函数生成信号幅值超过了1
car1=525;
car2=625;
am1=37;
am2=81;
fs=48000;
InitializePsychSound
dur_std=500;
dur_dev=250;
depth=1;
ramp=3;
[SEAP_525] = SEAPGEN(car1,am1,am2,fs,dur_std,depth,ramp);
[SEAP_625] = SEAPGEN(car2,am1,am2,fs,dur_std,depth,ramp);
[SEAP_time] = SEAPGEN(car2,am1,am2,fs,dur_dev,depth,ramp);

% Normalization
Nor_SEAP_525  = 2*(SEAP_525 - min(SEAP_525)) / (max(SEAP_525) - min(SEAP_525)) - 1;

timeIndex = linspace(0, dur_std, length(SEAP_525));
% plot Original Signal
subplot(121)
plot(timeIndex, SEAP_525)
set(gca,'fontsize',20)
title('Original Signal')
xlabel('Time (ms)')
ylabel('Amplitude')

% plot Normalized Signal
subplot(122)
plot(timeIndex, Nor_SEAP_525)
set(gca,'fontsize',20)
title('Normalized Signal')
xlabel('Time (ms)')
ylabel('Normalized Amplitude')

% calculate the correlation between the original signal and the normalized signal
correlation = corr(SEAP_525', Nor_SEAP_525');
fprintf('The correlation between the original signal and the normalized signal is: %.4f\n', correlation);

%% 2 对比归一化前后信号功率谱的差异
% calculate the psd of SEAP_525
data = SEAP_525 ;
% 计算FFT
n = length(data)-1;
Y = fft(data)/n;
f = fs*(0:(n/2))/n;

P = abs(Y).^2; % power spectrum
P = P(1:n/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT
P1 = P ;
figure
subplot(131)
plot(f, P);
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
title('Power Spectrum of SEAP_525');
grid on;
xlim([425 625])
clearvars -except Nor_SEAP_525 SEAP_525 fs P1
% calculate the psd of Nor_SEAP_525

data = Nor_SEAP_525 ;
n = length(data)-1;
Y = fft(data)/n; % normalized FFT
f = fs*(0:(n/2))/n;

P = abs(Y).^2; % power spectrum
P = P(1:n/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT
P2 = P ;
subplot(132)
plot(f, (P));
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
title('Power Spectrum of Nor_SEAP_525');
grid on;
xlim([425 625])

subplot(133)
plot(f,P1'./P2')
title('两者相差整数倍')

%% 3 audiowrite的对比
% 总结：
%  (1) 如果产生信号幅值为-1~1之间，则用audiowrite不会产生信号失真；
%（2) 如果产生信号幅值不在-1~1之间，则需要先归一化

audiowrite('SEAP_525_No_Nor.wav',SEAP_525,fs)
audiowrite('SEAP_525_Nor.wav',Nor_SEAP_525,fs)

[data, fs] = audioread([pwd filesep 'SEAP_525_No_Nor.wav']) ;

% calculate PSD
n = length(data)-1;
Y = fft(data)/n;
f = fs*(0:(n/2))/n;

P = abs(Y).^2; % power spectrum
P = P(1:n/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT
figure
subplot(131)
plot(f, (P));
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
title('Power Spectrum of SEAP_525_No_Nor.wav');
grid on;
xlim([425 625])

clearvars -except  P2

[data, fs] = audioread([pwd filesep 'SEAP_525_Nor.wav']) ;
% calculate PSD
n = length(data)-1;
Y = fft(data)/n;
f = fs*(0:(n/2))/n;

P = abs(Y).^2; % power spectrum
P = P(1:n/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT
subplot(132)
plot(f, (P));
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
title('Power Spectrum of SEAP_525_Nor.wav');
grid on;
xlim([425 625])

subplot(133)
plot(f, (P2));
xlabel('Frequency (Hz)');
ylabel('Power Spectrum');
title('Power Spectrum of Nor_SEAP_525');
grid on;
xlim([425 625])

%%
toc
