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
% 函数说明: CIC滤波器
% R       : 抽取因子
% M       : 差分延迟单元
% N       : 阶数
% data    : 未滤波信号
% fs      : 采样率
% n       : 点数(幅频响应曲线的频谱分辨率)
% fig     : 绘图
% cic_o   : 已滤波信号
% ofs     : 抽值采样率
function [cic_o, ofs] = vcic(R, M, N, data, fs, n, fig)
% ========================================================================\
%     ****         Define Parameter and Internal Signals          **** 
% ========================================================================/





% ========================================================================\
%     ****                       Main Code                        ****  
% ========================================================================/
% 保存
old = get(0, 'CurrentFigure');

% 滤波器设计
cic = dsp.CICDecimator(DecimationFactor = R, DifferentialDelay = M, NumSections = N);

% 列向量
data = data(:);

% 长度信息
len = length(data);

% 补0
if mod(len, R) ~= 0
    data = [data; zeros(R-mod(len,R)), 1];
end

% 滤波
cic_o  = cic(data);

% 增益
g = (R * M) ^ N;

% 输出
cic_o = cic_o/g;

if mod(len, R) ~= 0
    cic_o  = cic_o(1:end-1); % 补零多1个样点
end

% 采样率
ofs = fs/R;

% 绘图
if fig == 1
% 幅频响应曲线
[y, x] = vfreqz([], [], cic, n, fs);
figure;
plot(x, y); title(sprintf('幅频响应曲线(cic): fs = %dHz', fs)); xlabel('频率(Hz)'); ylabel('幅度');
end

% 恢复
if ~isempty(old) && ishghandle(old)
    figure(old);
end

end




