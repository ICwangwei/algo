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
% 函数说明: 频率控制字
% fclk    : 时钟频率
% fout    : 信号频率
% phase_n : 相位累加器位宽
% qn      : 量化位宽
% fcw_o   : 频率控制字(量化)
function [fcw_o] = fcw(fclk, fout, phase_n, qn)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 频率控制字
fcw_tmp = (fout * 2^phase_n) / fclk;

% 量化
fcw_o = round(fcw_tmp * 2^qn);

% 打印
fprintf('--- 频率控制字 ------------------------------------\n');
fprintf('时钟频率: %.3f Hz \n', fclk);
fprintf('信号频率: %.3f Hz \n', fout);
fprintf('相位累加器位宽: %d \n', phase_n);
fprintf('频率控制字(未量化): %.10f \n', fcw_tmp);
fprintf('频率控制字量化位宽: %d \n', qn);
fprintf('频率控制字(量化): %d \n', fcw_o);

end