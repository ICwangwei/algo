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
% fs : 采样频率(Hz)
% fps: 通带截止频率(Hz)
% fsp: 阻带截止频率(Hz)
% Rp : 通带最大衰减(dB)
% As : 阻带最大衰减(dB)
% log: 控制打印输出 'on' -- 开启打印 'off' -- 关闭打印
% n  : 阶数
% fc : -3dB截止频率(通带 - 过渡带 - 阻带)
function [n, fc] = vbuttord(fs, fps, fsp, Rp, As, log)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/



% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/

% 奈奎斯特频率归一化
fps = 2 * fps / fs;
fsp = 2 * fsp / fs;

% 计算
[n, fc] = buttord(fps, fsp, Rp, As);

% 打印
if(log == 'on')
fprintf('-- anbuttord ---------------------------\n');
fprintf('阶数 = %d\n', n);
fprintf('3dB截止频率(归一化) = %.4f \n', fc);
end

% 输出Hz
fc = fc * fs / 2;

% 继续打印
if(log == 'on')
fprintf('3dB截止频率(Hz) = %.2f Hz \n', fc);
end

end