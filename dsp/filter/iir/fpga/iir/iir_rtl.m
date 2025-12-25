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

% 滤波器
function [y] = iir_rtl(A01, A11, A21, B01, B11, B21, A02, A12, A22, B02, B12, B22, COE, DW, x)
% 第一基本节
[io] = iir_tap(A01, A11, A21, B01, B11, B21, COE, DW,  x);
% 第二基本节
[y]  = iir_tap(A02, A12, A22, B02, B12, B22, COE, DW, io);
% 数据类型
y = double(y);
% 转置
y = y.'; 
end

% 零点
function [y] = iir_zero(B0, B1, B2, BIN, COE, BOUT, x)

% 格式
ntBIN  = numerictype(true,     BIN, 0); 
ntCOE  = numerictype(true,     COE, 0);
ntBOUT = numerictype(true,    BOUT, 0);
ntMult = numerictype(true, BIN+COE, 0);

% 规则
fm = fimath('OverflowAction','Wrap', ...  % 溢出:回卷(丢高位)
            'RoundingMethod','Floor', ... % 舍入:向下取整
            'ProductMode','SpecifyPrecision', ... % 乘法规则: 位宽固定在BOUT+COE
            'ProductWordLength', BIN+COE, ...
            'ProductFractionLength', 0, ...
            'SumMode','SpecifyPrecision', ... % 加法规则: 位宽固定在BIN+2
            'SumWordLength', BOUT, ...
            'SumFractionLength', 0);    

% 系数
coe0 = fi(B0, ntCOE, fm);
coe1 = fi(B1, ntCOE, fm);
coe2 = fi(B2, ntCOE, fm);

% 寄存器
x_r1 = fi(0, ntBIN, fm);
x_r2 = fi(0, ntBIN, fm);

for n = 1:length(x)
    % 乘法
    P0 = fi(x(n), ntBIN, fm) * coe0;
    P1 = x_r1 * coe1;
    P2 = x_r2 * coe2;
    
    % 加法
    P0 = fi(P0, ntBOUT, fm);
    P1 = fi(P1, ntBOUT, fm);
    P2 = fi(P2, ntBOUT, fm);
    
    y(n) = P0 + P1 + P2;
    
    % 打拍
    x_r2 = x_r1;
    x_r1 = fi(x(n), ntBIN, fm); 

end

end

% 极点
function [y] = iir_pole(A0, A1, A2, BIN, COE, BOUT, x)

% 保卫位宽
Guard = 2;

% 格式/类型(有符号, 位宽, 小数位宽)
ntBIN  = numerictype(true,           BIN, 0); 
ntCOE  = numerictype(true,           COE, 0);
ntBOUT = numerictype(true,          BOUT, 0);
ntMult = numerictype(true,      BOUT+COE, 0);
ntSUM  = numerictype(true, BIN+2+1+Guard, 0);

% 规则
fm = fimath('OverflowAction','Wrap', ...  % 溢出:回卷(丢高位)
            'RoundingMethod','Floor', ... % 舍入:向下取整
            'ProductMode','SpecifyPrecision', ... % 乘法规则: 位宽固定在BOUT+COE
            'ProductWordLength', BOUT+COE, ...
            'ProductFractionLength', 0, ...
            'SumMode','SpecifyPrecision', ... % 加法规则: 位宽固定在BIN+2
            'SumWordLength', BIN+2, ...
            'SumFractionLength', 0);    

% 系数
coe1 = fi(A1, ntCOE, fm);
coe2 = fi(A2, ntCOE, fm);

% 寄存器
x_r1 = fi(0,  ntBIN, fm);
x_r2 = fi(0,  ntBIN, fm);
y_r1 = fi(0, ntBOUT, fm);
y_r2 = fi(0, ntBOUT, fm);
    
for n = 1:length(x)
    % 乘法
    P1 = y_r1 * coe1;
    P2 = y_r2 * coe2;
    
    % 补偿(移位实现除法会导致损失的0.5*LSB)
    comp = fi(bitshift(2, A0-2), ntSUM, fm);
    
    % 加法
    tmp_x  = fi(x(n), ntSUM, fm); % {{(2){x_r2[BIN-1]}},x_r2}
    P1     = fi(P1,   ntSUM, fm); % {{(4){P1[BOUT+COE-1]}},P1}
    P2     = fi(P2,   ntSUM, fm); % {{(4){P2[BOUT+COE-1]}},P2}
    
    vsum = tmp_x - P1 - P2 + comp;
    
    % 除法
    vdiv = bitsra(vsum, A0); % {{(A0){sum[BIN+2-1]}},sum[BIN+2-1:A0]}
    
    % 截位
    yin = fi(vdiv, ntBOUT, fm);
    
    % 打拍
    x_r2 = x_r1;
    x_r1 = fi(x(n), ntBIN, fm);
    y_r2 = y_r1;
    y_r1 = yin;
    
    % 输出
    y(n) = int64(yin.int);

end
    
end

% 基本节
function [y] = iir_tap(A0, A1, A2, B0, B1, B2, COE, DW, x)
% 零点
[io] = iir_zero(B0, B1, B2, DW, COE, DW+COE+2, x);
% 极点
[y] = iir_pole(A0, A1, A2, DW+COE+2, COE, DW, io);

end

% 基本节
function [y] = iir_tap_wrapper(A0, A1, A2, B0, B1, B2, COE, DW, x)
    EXP_DW = DW + 1;
    y = iir_tap(A0, A1, A2, B0, B1, B2, COE, EXP_DW, x);
end
