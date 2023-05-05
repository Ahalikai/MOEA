function mop = testmop(testname, dimension)
    %   testname: 多目标问题
    %   dimension: 问题维度

    mop = struct('name', [], 'od', [], 'pd', [], 'domain', [], 'func', []);

    switch lower(testname)
        case 'kno1'
            mop = kno1(mop);
        case 'zdt1'
            mop = zdt1(mop, dimension);
        otherwise
            error('Undefined test problem name');
    end
end

%   KNO1 problem
function p = kno1(p)
    p.name = 'KNO1';
    p.od = 2; % object dimension
    p.pd = 2; % 参数 dimension
    p.domain = [0.3; 0.3]; % 定义域
    p.func = @evaluate; % 评价函数
    
    % KNO1 evaluate function
    function y = evaluate(x)
        y = zeros(2, 1);
        c = x(1) + x(2);
        f = 9 - (3 * sin(2.5 * c ^ 0.5) + ...
            3 * sin(4 * c) + 5 * sin(2 * c + 2));
        g = (pi / 2.0) * (x(1) - x(2) + 3.0) / 6.0;
        y(1) = 20 - (f * cos(g));
        y(2) = 20 - (f * sin(g));
    end
end

%   ZDT1 problem
function p = zdt1(p, dim)
    p.name = 'ZDT1';
    p.od = 2;
    p.pd = dim;
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    function y = evaluate(x)
        y = zeros(2, 1);
        y(1) = x(1);
        su = sum(x) - x(1);
        g = 1 + 9 * su / (dim - 1);
        y(2) = g * (1 - sqrt(x(1) / g));
    end
end