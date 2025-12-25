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
% 函数说明: CIC插值滤波器
% I       : 插值因子
% M       : 差分单元
% N       : 阶数
% data    : 待滤波数据
% fs      : 采样率
% n       : 点数(绘制幅频响应曲线)
% fig     : 绘图控制
% cic_o   : 已滤波信号
% fs_o    : 插值采样率
function [cic_o, fs_o] = vcic2(I, M, N, data, fs, n, fig)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 保存
old = get(0, 'CurrentFigure');

% 滤波器设计
cic = dsp.CICInterpolator(InterpolationFactor = I, DifferentialDelay = M, NumSections = N); % 零插 + 平滑

% 列向量
data = data(:);

% 滤波
cic_o = cic(data);

% 增益
g = ((I * M) ^ N) / I;

% 输出
cic_o = cic_o/g;

% 采样率
fs_o = fs * I;

% 幅频响应
[y,x] = vfreqz([], [], cic, n, fs);

% 绘图
if fig == 1
figure;
plot(x, y); title(sprintf('幅频响应曲线(CIC插值): fs = %dHz, fs_o = %dHz', fs, fs_o)); xlabel('频率(Hz)'); ylabel('幅度');
end

% 恢复
if ~isempty(old) && ishghandle(old)
    figure(old);
end


end