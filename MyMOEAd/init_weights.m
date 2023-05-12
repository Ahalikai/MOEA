function subp = init_weights(popsize, niche, objDim)
    subp = [];
    for i = 0 : popsize
        if objDim == 2
            p = struct('weights', [], 'neighbour', [], 'optimal', Inf, ...
                'optpoint', [], 'curpoint', []);

            % 平均划分， 定义每个子问题的权值
            weight = zeros(2, 1);
            weight(1) = i / popsize;
            weight(2) = (popsize - i) / popsize;
            p.weight = weight;
            subp = [subp p];
        elseif objDim == 3
            % TODO
        end
    end

    % 定义邻居
    leng = length(subp);
    distanceMatrix = zeros(leng, leng);

    for i = 1 : leng
        for j = 1 + 1 : leng
            A = subp(i).weight;
            B = subp(j).weight;
            distanceMatrix(i, j) = (A - B)' * (A - B);
            distanceMatrix(j, i) = distanceMatrix(i, j);
        end

        [s, sindex] = sort(distanceMatrix(i, :));
        subp(i).neighbour = sindex(1 : niche)';
end