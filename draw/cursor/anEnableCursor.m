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
% 函数说明: 在绘图中增加X/Y轴线，并在交界处标注值。
function anEnableCursor(axs)

if nargin < 1 || isempty(axs)
    axs = gca;
end

axs = axs(isgraphics(axs, 'axes'));

if isempty(axs)
    return;
end

fig = ancestor(axs(1), 'figure');

% 检查Matlab是否支持常量线
hasConstLine = ~isempty(which('xline')) && ~isempty(which('yline'));

% 预分配存放每个轴的十字线
S = struct('ax', {}, 'vx', {}, 'hy', {}, 'ht', {});
for i = 1:numel(axs)
    ax = axs(i);
    hold(ax, 'on');
    
    % 根据当前轴的坐标范围，选择十字线的初始位置(中心)
    xl = ax.XLim;
    yl = ax.YLim;
    if strcmpi(ax.XScale, 'log')
        x0 = 10.^mean(log10(xl));
    else
        x0 = mean(xl);
    end
    y0 = mean(yl);
    
    % 创建十字线
    if hasConstLine
        vx = xline(ax, x0, '-', 'Color', [1 0 0], 'LineWidth', 0.8, 'HitTest', 'off', 'PickableParts', 'none');
        hy = yline(ax, y0, '-', 'Color', [0 0 1], 'LineWidth', 0.8, 'HitTest', 'off', 'PickableParts', 'none');
    else 
        vx = line(ax, [x0 x0], yl, 'Color', [1 0 0], 'LineWidth', 0.8, 'HitTest', 'off', 'PickableParts', 'none');
        hy = line(ax, xl, [y0 y0], 'Color', [0 0 1], 'LineWidth', 0.8, 'HitTest', 'off', 'PickableParts', 'none');
    end
    % 创建读数文本
    ht = text(ax, x0, y0, '', 'BackgroundColor', 'w', 'Margin', 2, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'Clipping', 'on', 'Interpreter', 'none', 'HitTest', 'off');
    
    % 存入结构体便于在回调中定位和更新
    S(i).ax = ax;
    S(i).vx = vx;
    S(i).hy = hy;
    S(i).ht = ht;
    % 初始全部隐藏，鼠标走到对应轴再显示
    set([vx hy ht], 'Visible', 'off');
end

% 将结构体保存，供回调访问
setappdata(fig, 'CrosshairData', S);

% 注册鼠标移动回调
set(fig, 'WindowButtonMotionFcn', @anMoveCursorCallback);
end


% 函数说明: 鼠标回调
function anMoveCursorCallback(src, ~)

% 检查
if ~ishandle(src) || ~isgraphics(src, 'figure')
    return;
end

S = getappdata(src, 'CrosshairData');
if isempty(S)
    return;
end

% 查找鼠标下方对象，并向上追溯其所属axes
h = hittest(src);
ax = ancestor(h, 'axes');
if isempty(ax) || ~isvalid(ax)
    ax = get(src, 'CurrentAxes');
    if isempty(ax) || ~isvalid(ax)
        return;
    end
end

% 在受管列表中找到该轴的索引
idx = find(arrayfun(@(s) isequal(s.ax, ax), S), 1);
if isempty(idx)
    return;
end

% 获取鼠标坐标
cp = get(ax, 'CurrentPoint');
x = cp(1, 1);
y = cp(1, 2);
xlim_ = get(ax, 'XLim');
ylim_ = get(ax, 'YLim');

% 若鼠标超出范围则隐藏十字线和文本
if x < min(xlim_) || x > max(xlim_) || y < min(ylim_) || y > max(ylim_)
    for k = 1:numel(S)
        set([S(k).vx S(k).hy S(k).ht], 'Visible', 'off');
    end
    return;
end

% 仅当前轴的对象可见，其余轴的对象隐藏
for k = 1:numel(S)
    vis = 'off';
    if k == idx
        vis = 'on';
    end
    if isvalid(S(k).vx)
        set(S(k).vx, 'Visible', vis);
    end
    if isvalid(S(k).hy)
        set(S(k).hy, 'Visible', vis);
    end
    if isvalid(S(k).ht)
        set(S(k).ht, 'Visible', vis);
    end
end

% 更新十字线和文本
s = S(idx);

if isprop(s.vx, 'Value')
    s.vx.Value = x;
    s.hy.Value = y;
else
    set(s.vx, 'XData', [x x], 'YData', ylim_);
    set(s.hy, 'XData', xlim_, 'YData', [y y]);
end
set(s.ht, 'Position', [x y 0], 'String', sprintf('x = %.6g, y = %.6g', x, y));

% 写回结构体
S(idx) = s;
setappdata(src, 'CrosshairData', S);

end
