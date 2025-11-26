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
% 函数说明: 根据性能指标计算阶数和截止频率
% fs      : 采样率(Hz)
% fps     : 通带截止频率(Hz)
% fsp     : 阻带截止频率(Hz)
% Rp      : 通带最大衰减(dB)
% As      : 阻带最大衰减(dB)
% log     : 打印控制
% n       : 阶数
% fc      : -3dB截止频率(Hz)
function [n, fc] = vcheb2ord(fs, fps, fsp, Rp, As, log)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/

% 归一化
Wp = 2 * fps / fs;
Ws = 2 * fsp / fs;

% 计算
[n, Wc] = cheb2ord(Wp, Ws, Rp, As);

% Hz
fc = Wc * fs / 2;

% 打印
if log == 1
fprintf('-- 切比雪夫II型 ---------------------------\n');
fprintf('阶数 = %d \n', n);
fprintf('3dB截止频率(归一化) = %.4f \n', Wc);
fprintf('3dB截止频率(Hz) = %.2f Hz \n', fc);
end

end