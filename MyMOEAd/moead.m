function pareto = moead(mop, varargin)
    startTime = clock;
    global params idealPoint objDim parDim itrCounter;
    rand('state', 10);

    paramIn = varargin;
    [objDim, parDim, idealPoint, params, subproblems] = init(mop, paramIn);

    itrCounter = 1;

    % main
    while ~terminate(itrCounter)
        tic;
        subproblems = evolve(subproblems, mop, params);
        disp(sprintf('Iteration %u finished, time used: %u', itrCounter, toc));
        itrCounter = itrCounter + 1;
    end

    pareto = [subproblems.curpoint];
    pp = [pareto.objective];
    scatter(pp(1, :), pp(2, :));
    disp(sprintf('Total time used %u', etime(clock, startTime)));
end

function [objDim, parDim, idealp, params, subproblems] = init(mop, propertyArgIn)
    % Inital setting of MOEA/D.
    objDim = mop.od;
    parDim = mop.pd;
    idealp = ones(objDim, 1) * inf;

    % Other default
    params.popsize = 100;
    params.niche = 30;
    params.iteration = 100;
    params.dmethod = 'ts';
    params.F = 0.5;
    params.CR = 0.5;

    % handle the params
    while length(propertyArgIn) >= 2
        prop = propertyArgIn{1};
        val = propertyArgIn{2};
        propertyArgIn = propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize = val;
            case 'niche'
                params.niche = val;
            case 'iteration'
                params.iteration = val;
            case 'method'
                params.dmethod = val;
            otherwise
                warning('MOEA/d params is error!')
        end
    end

    % Decompose objective
    subproblems = init_weights(params.popsize, params.niche, objDim);
    params.popsize = length(subproblems);

    % Initial point
    inds = randomPoint(mop, params.popsize);

    % Initial evaluate & Save bestPoint in ideal
    [V, INDS] = arrayfun(@evaluate, repmat(mop, size(inds)), inds, 'UniformOutput', 0);
    v = cell2mat(V);
    idealp = min(idealp, min(v, [], 2));

    [subproblems.curpoint] = INDS{:};
    clear inds INDS V;
end

function subproblems = evolve(subproblems, mop, params)
    global idealPoint;

    for i = 1:length(subproblems)
        ind = genetic_op(subproblems, i, mop.domain, params);
        [obj, ind] = evaluate(mop, ind);

        idealPoint = min(idealPoint, obj);

        % Updata the neighbours.
        neighborIndex = subproblems(i).neighbour;
        subproblems(neighborIndex) = updata(subproblems(neighborIndex), ind, idealPoint);

        clear ind obj neighborIndex;
    end
end

function subp = updata(subp, ind, idealPoint)
    global params;

    newObj = subObjective([subp.weight], ind.objective, idealPoint, params.dmethod);
    oops = [subp.curpoint];
    oldObj = subObjective([subp.weight], [oops.objective], idealPoint, params.dmethod);

    C = newObj < oldObj;
    [subp(C).curpoint] = deal(ind);
    clear C newObj oops oldObj;
end

function y = terminate(itrCounter)
    global params;
    y = itrCounter > params.iteration;
end




















