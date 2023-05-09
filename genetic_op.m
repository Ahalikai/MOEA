function ind = genetic_op(subproblems, index, domain, params)
    % 采用DE
    % subproblems 所有的子问题
    % index 子问题的编号
    % domain 定义域
    % params 解的结构
    neighbourindex = subproblems(index).neighbour;

    nsize = length(neighbourindex);
    si = ones(1, 3) * index;

    si(1) = neighbourindex(ceil(rand * nsize));
    while si(1) == index
        si(1) = neighbourindex(ceil(rand * nsize));
    end

    si(2) = neighbourindex(ceil(rand * nsize));
    while si(2) == index || si(2) == si(1)
        si(2) = neighbourindex(ceil(rand * nsize));
    end

    si(3) = neighbourindex(ceil(rand * nsize));
    while si(3) == index || si(3) == si(1) || si(3) == si(2)
        si(3) = neighbourindex(ceil(rand * nsize));
    end

    points = [subproblems(si).curpoint];
    selectpoints = [points.parameter];

    oldpoint = subproblems(index).curpoint.parameter;
    parDim = size(domain, 1);

    jrandom = ceil(rand * parDim);

    randomarray = rand(parDim, 1);
    deselect = randomarray < params.CR;
    deselect(jrandom) = true;
    newpoint = selectpoints(:, 1) + params.F * (selectpoints(:, 2) - selectpoints(:, 3));
    newpoint(~deselect) = oldpoint(~deselect);

    % 替换新的解
    newpoint = max(newpoint, domain(:, 1));
    newpoint = min(newpoint, domain(:, 2));

    ind = struct('parameter', newpoint, 'objective', [], 'estimation', []);
    ind = gaussian_mutate(ind, 1 / parDim, domain);
end