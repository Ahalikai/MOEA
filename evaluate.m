function [v, x] = evaluate(prob, x)
    if isstruct(x)
        v = prob.func(x.parameter);
        x.objective = v;
    else
        v = prob.func(x);
    end
end