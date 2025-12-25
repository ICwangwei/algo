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
function [] = ifstream(fpath, fname, data)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 打开文件
file = fopen(fullfile(fpath, fname), 'w+');
if file == -1
    error(sprintf('[%s]: 无法打开文件... \n', fname));
end

% 打印
fprintf(file, '%08x \r\n', data(1:end));

% 关闭
fclose(file);

end