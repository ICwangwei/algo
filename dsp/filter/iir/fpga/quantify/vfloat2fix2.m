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
function [sos, B, A] = vfloat2fix2(g, b, a, fpga_n)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 二阶基本节的数量
len = size(b, 1);
sos = zeros(len, 6);
Qb  = zeros(len, 3);
Qa  = zeros(len, 3);

% 量化
% 第一个基本节
[Qb(1,:), Qa(1,:)] = vfloat2fix(g * b(1,:), a(1,:), fpga_n);
sos(1,:) = [Qb(1,:), Qa(1,:)];

% 其余基本节
for i = 2:len
    [Qb(i,:), Qa(i,:)] = vfloat2fix(b(i,:), a(i,:), fpga_n);
    sos(i,:) = [Qb(i,:), Qa(i,:)];
end

% 输出
B = Qb;
A = Qa;

end