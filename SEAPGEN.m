function [SEAP] = SEAPGEN(car,am1,am2,fs,dur,depth,ramp)
%SEAPGEN% GENERATES SEAP STIMULUS WITH USER-DEFINED PARAMETERS
% Author: Chris Slugocki
% Revision Date: 11/18/2014

% The SEAPGEN function creates an amplitude-modulation pure-tone stimulus
% with the following parameters:

% car = carrier frequency
% am1 = amplitude modulation frequency 1
% am2 = amplitude modulation frequency 2
% fs = sampling rate 
% dur = stimulus duration (in milliseconds)
% depth = modulation depth (proportion between 0 and 1)
% ramp = duration of cosine ramp (in milliseconds)

% Check input parameters:
if 0 > depth
    error('SEAPGEN:dep','AM depth must be a proportion between 0 and 1');
elseif depth > 1
    error('SEAPGEN:dep','AM depth must be a proportion between 0 and 1');
end
if car >= fs/2;
    error('SEAPGEN:car','Carrier frequency (car) cannot exceed fs/2');
end
if am1 >= fs/2;
    error('SEAPGEN:car','AM frequency 1 (am1) cannot exceed fs/2');
end
if am2 >= fs/2;
    error('SEAPGEN:car','AM frequency 2 (am2) cannot exceed fs/2');
end
if ramp >=(dur/2)
    error('SEAPGEN:ramp','Ramp duration cannot exceed (stimulus duration)/2');
end

% Design the SEAP stimulus:
t=(0:1/fs:dur/1000);
A=1;
c=A*sin(2*pi*car*t);
a1=A*sin(2*pi*am1*t)+depth;%a1 是目标频率1，car为载波
a2=A*sin(2*pi*am2*t)+depth;
amsum = a1+a2;
SEAP=c.*amsum;

% Prepare cosine up-ramp:上升沿
tr = (0:1/fs:ramp/1000);
fr = 1/(ramp/1000)*0.25;
ru = (sin(2*pi*fr*tr)).^2;
ts = (dur/1000)*fs+1;
diff = ts-length(ru);
ru = [ru,ones(1,diff)];%ones,返回一个全1的矩阵,将他们连接成一个向量，1.1.1  2.1.1

% Prepare cosine down-ramp:下降沿
rd = (cos(2*pi*fr*tr)).^2;
rd = [ones(1,diff),rd];

% Ramp-up/down SEAP stimulus:
SEAP=SEAP.*ru;
SEAP=SEAP.*rd;
end

