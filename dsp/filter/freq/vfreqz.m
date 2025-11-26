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
% 函数说明: 幅频响应曲线【注意:函数freqz()是理论值，而delta因为长度有限只是近似值】
% b       : (直接型)系统函数分子
% a       : (直接型)系统函数分母
% sos     : 级联型二阶节系数标准
% n       : 点数(影响频谱分辨率)
% fs      : 采样率
% y       : 幅频响应纵坐标(dB)
% x       : 幅频响应横坐标(Hz)
function [y, x] = vfreqz(b, a, sos, n, fs)

% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/

% 级联型
iir_cas = ~isempty(sos) && (isempty(b) || isempty(a));

% 直接型
iir_dir = ~isempty(b) && ~isempty(a) && isempty(sos);

% 判断
if iir_cas == 1
    [h, w] = freqz(sos, n);
elseif iir_dir == 1
    [h, w] = freqz(b, a, n);
else
    error('幅频响应曲线"freqz"绘制错误! \n');
end

% 纵坐标(dB)
y = 20 * log10(abs(h));

% 横坐标(Hz)
x = w * fs / (2 * pi);

end