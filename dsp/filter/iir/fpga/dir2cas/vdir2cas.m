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
% 函数说明: 将直接型结构IIR滤波器的系数转成级联型结构IIR滤波器的系数
% b       : 直接型结构IIR滤波器系统函数的分母项系数
% a       : 直接型结构IIR滤波器系统函数的分子项系数
% b0      : 增益系数
% B       : 包含因子系数bk的K行3列矩阵
% A       : 包含因子系数ak的K行3列矩阵
function [b0, B, A] = vdir2cas(b, a)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
b0 = b(1); b = b/b0;
a0 = a(1); a = a/a0; b0 = b0/a0;

% 将分子项系数、分母项系数的长度补齐后再进行计算
M = length(b); N = length(a);
if N > M
    b = [b zeros(1, N-M)];
elseif M > N
    a = [a zeros(1, M-N)]; N = M;
else 
    N = M;
end

% 初始化级联型结构IIR滤波器的系数矩阵
K = floor(N/2); B = zeros(K, 3); A = zeros(K, 3);
if K * 2 == N
    b = [b 0]; a = [a 0];
end

% 根据多项式系数利用roots()函数求出所有的根
% 利用cplxpair()函数按实部从小到大的顺序进行排序
broots = cplxpair(roots(b));
aroots = cplxpair(roots(a));

% 将计算复共轭对的根转换成多项式系数
for i = 1:2:2*K
    Brow = broots(i:1:i+1,:);
    Brow = real(poly(Brow));
    B(fix(i+1)/2,:) = Brow;
    Arow = aroots(i:1:i+1,:);
    Arow = real(poly(Arow));
    A(fix(i+1)/2,:) = Arow;
end

end