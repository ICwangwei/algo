% ************************************************************************ 
% Project Name :       
% Module       : *.m
% Software     : 
% Language     : M
% 
% Author       : wang.wei 
% Email        : wangwei3@topscomm.com  
% Telephone    : 
% Company      : ainuo
% Engineer     : fpgaer
% 
% Create Time  : 
%  
% ************************************************************************ 
% Module function:
%  
% 
% 
% 
% All Right Reserved 
% ************************************************************************ 
% Modification History:
% Date          By          Version          Change Description 
% ------------------------------------------------------------------------ 
%             Ainuo           1.0                Original       
% 
% ************************************************************************ 
% 函数说明: 幅度谱
% data    : 实信号
% fs      : 采样率
% y       : 幅度
% x       : 频率Hz
function [y, x] = vfft(data, fs);
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 长度信息
fft_n = numel(data);

% 快速傅里叶变换
fft_o = fft(data);

% 横坐标
idx = 0:(fft_n-1);

% 有效频谱
idx(idx >= fft_n/2) = idx(idx >= fft_n/2) - fft_n;

% 频谱分辨率
idx = idx.*(fs/fft_n); % Hz

% 纵坐标
fft_abs = abs(fft_o);

% 输出
x = idx;
y = fft_abs;

end