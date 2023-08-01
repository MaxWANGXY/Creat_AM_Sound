clc
clear
close all
tic
%% 1 调频声音刺激

flag_filter = 1

load AM_Epoch.mat
% 选择单通道或者多通道
Chan_AVG_data = squeeze(mean(data([1:2],:,:),1)) ;
% 选择平均的试次数量
Wav4PSD = squeeze(mean(Chan_AVG_data(TimeIndex>=150 & TimeIndex<=450,:),2))' ;

%% 滤波器设置
if flag_filter
    % 设定滤波器频率边界
    lowcut = 30;
    highcut = 50;

    % 设定滤波器阶数
    order = 6; % 这是一个常用的值，但你可以根据需要调整

    % 创建滤波器
    [b, a] = butter(order, [lowcut highcut]/(Fs/2), 'bandpass');

    % 应用滤波器
    filtered_signal = filtfilt(b, a, double(Wav4PSD));

    clear Wav4PSD
    Wav4PSD = filtered_signal ;
end


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
xlim([25 50]);

%% 2 非调频声音刺激
clearvars -except flag_filter

load No_AM_Epoch.mat
% 选择单通道或者多通道
Chan_AVG_data = squeeze(mean(data([1:2 ],:,:),1)) ;
% 选择平均的试次数量
Wav4PSD = squeeze(mean(Chan_AVG_data(TimeIndex>=150 & TimeIndex<=350,:),2))' ;

if flag_filter
    % 设定滤波器频率边界
    lowcut = 30;
    highcut = 50;

    % 设定滤波器阶数
    order = 6; % 这是一个常用的值，但你可以根据需要调整

    % 创建滤波器
    [b, a] = butter(order, [lowcut highcut]/(Fs/2), 'bandpass');

    % 应用滤波器
    filtered_signal = filtfilt(b, a, double(Wav4PSD));

    clear Wav4PSD
    Wav4PSD = filtered_signal ;
end

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
