function obj = subObjective(weight, ind, idealpoint, method)
%% 求解g^{te}或者g^{ws}值
%   应用切比雪夫和加权和两种方法
%   weight: 所有子问题的权重向量 (列向量).
%   ind: 新解的目标函数值 (列向量)/所有子问题的当前解的目标函数值（列向量集）.
%   idealpoint: 当前的参考点的目标函数值.
%   method: 选择的分解方法，默认是切比雪夫“te”
%   nargin: 函数输入参数个数
%   
%   weight和ind也可以是矩阵，有如下两种情况：
%  （1）当weight是矩阵时，它就被看作按列排列的权重集。在这种情况下，如果ind
%   是一个列向量(输入新解的目标函数值)，subobjective就使用每一个权重和ind计
%   算；
%  （2）如果 ind 也是一个与weight大小相同的矩阵(输入所有子问题当前解的目标
%   函数值)，那么子目标将在列到列中计算，权重的每一列都针对 ind 的相应列进
%   行计算。
%
%   在上述两种情况中，subobjective都会返回一个行向量。

    if (nargin==2) % nargin 输入的参数个数
        obj = ws(weight, ind);
    elseif (nargin==3)
        obj = te(weight, ind, idealpoint);
    else
        if strcmp(method, 'ws');
            obj = ws(weight, ind);
        elseif strcmp(method, 'te');
            obj = te(weight, ind, idealpoint);
        else
            obj = te(weight, ind, idealpoint);
        end
    end
end

function obj = ws(weight, ind)
    if size(ind, 2) == 1
        obj = (weight'*ind)';
    else
        obj = sum(weight.*ind);
    end
end

function obj = te(weight, ind, idealpoint)
    s = size(weight, 2);
    indsize = size(ind, 2);

    weight((weight == 0)) = 0.00001;

    if indsize == s
        part2 = abs(ind - idealpoint(:, ones(1, indsize)));
        obj = max(weight.*part2);
    elseif indsize == 1
        part2 = abs(ind - idealpoint);
        obj = max(weight.*part2(:,ones(1, s)));
    else
        error('individual size must be same as weight size, or equals 1');
    end
end