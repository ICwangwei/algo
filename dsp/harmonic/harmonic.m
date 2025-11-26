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
% 函数说明: 谐波计算
% data    : 实信号
% H       : 谐波次数
% f       : 基波频率
% fs      : 采样率
% pic     : 绘图控制
% Harm_o  : 谐波分量
function [Harm_o] = harmonic(data, H, f, fs, pic)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 保存
oldFig = get(0, 'CurrentFigure');

% 长度信息
fft_n = numel(data);

% 快速傅里叶变换
fft_o = fft(data);

% 基波索引
M = round(f * fft_n / fs);

% 谐波索引
idx = (1:H).*M+1;
idx(idx > fft_n) = []; % 防止越界

% 谐波
Harm_o = 2 * abs(fft_o(idx)) / fft_n;
if numel(Harm_o) < H
    Harm_o(end+1:H, 1) = NaN;
end

% 绘图
idx = 0:(fft_n-1);

% 有效频谱
idx(idx >= fft_n/2) = idx(idx >= fft_n/2) - fft_n;

% 频谱分辨率
idx = idx.*(fs/fft_n);

% 绘图
if pic == 1
figure;
plot(idx, abs(fft_o)); title(sprintf('幅度谱:%.3fHz', fs)); xlabel('频率(Hz)'); ylabel('幅度');
end

% 恢复
if ~isempty(oldFig) && ishghandle(oldFig)
    figure(oldFig); % 切回
end

end