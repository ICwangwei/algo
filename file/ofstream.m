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
function [data] = ofstream(fpath, fname)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 打开文件
file = fopen(fullfile(fpath, fname), 'r');
if file == -1
    error(sprintf('[%s]: 无法打开文件... \n', fname));
end

% 读取文件内容
data = fscanf(file, '%x');

% 关闭文件
fclose(file);



end