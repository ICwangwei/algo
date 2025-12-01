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
% 函数说明: FIR滤波器抽头量化
% b       : 离散系统函数的分子
% fpga_n  : 量化位宽
% log     : 打印量化后的抽头系数
% coe     : 控制是否生成coe文件
% B       : 已量化的抽头系数
function [B] = vfloat2fix3(b, fpga_n, log, coe)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 系数归一化
b = b / max(abs(b));

% 量化
b = b * (2^(fpga_n-1)-1);

% 输出
B = round(b);

% 打印
if log == 1
fprintf('--- 抽头系数 --------------------------------------------------- \n');
fprintf('B = ');
fprintf('%d, ', B(1:end-1));
fprintf('%d  ', B(end:end));
fprintf('\n');
end

% 生成COE文件
if ~isempty(coe)
fid = fopen(fullfile(coe), 'w+');
fprintf(fid,'MEMORY_INITIALIZATION_RADIX=10; \n');
fprintf(fid,'MEMORY_INITIALIZATION_VECTOR= \n');
fprintf(fid,'%d, \n', B(1:end-1));
fprintf(fid,'%d; \n', B(end:end));
fclose(fid);
end

end