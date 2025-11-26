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
% 函数说明: 滤波器
% b       : 离散系统函数的分子
% a       : 离散系统函数的分母
% data    : 信号序列
% fs      : 采样率
% pic     : 绘图控制
% filter_o: 已滤波信号
function [filter_o] = vfilter(b, a, data, fs, pic)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 保存
oldFig = get(0, 'CurrentFigure');

% 滤波器
filter_o = filter(b, a, data);

% 创建系统函数对象
H = tf(b, a, 1/fs, 'Variable', 'z^-1');

% 幅频响应
[mag, phase, w] = bode(H);

% 角频率转频率
f = w / (2 * pi);

% 幅频响应
if pic == 1
figure;
ax1 = subplot(1, 1, 1);
semilogx(f, 20*log10(squeeze(mag)));
ylabel('幅度衰减(dB)');
title('幅频特性曲线');
grid on;
end

% % 相频响应
% if pic == 1
% ax2 = subplot(2, 1, 2);
% semilogx(f, squeeze(phase));
% xlabel('频率(Hz)');
% ylabel('相位(度)');
% title('相频特性曲线');
% grid on;
% end

% 启用十字交叉线
if pic == 1
    anEnableCursor([ax1]);
end

% 恢复
if ~isempty(oldFig) && ishghandle(oldFig)
    figure(oldFig);
end

end