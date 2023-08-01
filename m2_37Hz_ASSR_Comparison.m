clc
clear
close all
tic
%% 1 调频声音刺激
load AM_Epoch.mat
% 选择单通道或者多通道
Chan_AVG_data = squeeze(mean(data([1:2 ],:,:),1)) ;
% 选择平均的试次数量
Wav4PSD = squeeze(mean(Chan_AVG_data(TimeIndex>=150 & TimeIndex<=450,:),2))' ;

% 零填充以达到1Hz的频谱分辨率
N = 5000; % 零填充后的样本数量
padded_data = [Wav4PSD, zeros(1, N-length(Wav4PSD))];


Y = fft(padded_data)/N;
f = Fs*(0:(N/2))/N;

P = abs(Y).^2; % power spectrum
P = P(1:N/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT


% 画出功率谱
figure;
subplot(121)
plot(f, (P),'LineWidth',5);
set(gca,'fontsize',30)
xlabel('Frequency (Hz)');
ylabel('Power ');
title('AM-Epoch');
xlim([30 44]);

%% 2 非调频声音刺激
clear

load No_AM_Epoch.mat
% 选择单通道或者多通道
Chan_AVG_data = squeeze(mean(data([1:2 ],:,:),1)) ;
% 选择平均的试次数量
Wav4PSD = squeeze(mean(Chan_AVG_data(TimeIndex>=150 & TimeIndex<=350,:),2))' ;

% 零填充以达到1Hz的频谱分辨率
N = 5000; % 零填充后的样本数量
padded_data = [Wav4PSD, zeros(1, N-length(Wav4PSD))];


Y = fft(padded_data)/N;
f = Fs*(0:(N/2))/N;

P = abs(Y).^2; % power spectrum
P = P(1:N/2+1); % only keep positive frequency components
P(2:end-1) = 2*P(2:end-1); % account for the symmetry of the FFT

% 画出功率谱
subplot(122)
plot(f, (P),'LineWidth',5);
set(gca,'fontsize',30)
xlabel('Frequency (Hz)');
ylabel('Power ');
title('No-AM-Epoch');
xlim([30 44]);


%%
toc
