
function [pop, archive] = moead(problem, pop_size, archive_size, max_gen)
    % 初始化种群
    pop = initialize_population(pop_size, problem);
    
    % 初始化权重向量
    weights = initialize_weights(pop_size);
    
    % 初始化参考点
    ref_point = zeros(1, problem.n_obj);
    
    % 初始化邻居索引
    neighborhood = initialize_neighborhood(pop_size);
    
    % 迭代进化
    for gen = 1:max_gen
        % 更新参考点
        ref_point = update_reference_point(pop, ref_point);
        
        % 对每个个体进行邻居交叉和变异操作
        for i = 1:pop_size
            % 选择父代个体
            parents = select_parents(pop, neighborhood(i,:), problem);
            
            % 邻居交叉操作
            child = crossover(parents, weights(i,:), problem);
            
            % 变异操作
            child = mutate(child, problem);
            
            % 计算子代个体在目标空间的函数值
            child.obj = evaluate_objective(child, problem);
            
            % 更新参考点
            ref_point = update_reference_point(child, ref_point);
            
            % 更新邻居中的个体
            pop = update_population(pop, child, neighborhood(i,:), weights(i,:), ref_point);
        end
        
        % 将新生成的解加入到存档中
        archive = update_archive(pop, archive, archive_size);
        
        % 显示当前进化代数
        disp(['Generation: ', num2str(gen)]);
    end
end

function pop = initialize_population(pop_size, problem)
    pop = repmat(problem.var_range(:,1)', pop_size, 1) + ...
          repmat((problem.var_range(:,2) - problem.var_range(:,1))', pop_size, 1) .* ...
          rand(pop_size, problem.n_var);
end

function weights = initialize_weights(pop_size)
    weights = lhsdesign(pop_size, pop_size, 'criterion', 'maximin');
    weights = weights ./ repmat(sum(weights, 2), 1, pop_size);
end

function neighborhood = initialize_neighborhood(pop_size)
    neighborhood = zeros(pop_size, pop_size-1);
    for i = 1:pop_size
        [~, idx] = sort(rand(1, pop_size));
        neighborhood(i,:) = idx(idx ~= i);
    end
end

function ref_point = update_reference_point(pop, ref_point)
    ref_point = min(ref_point, max(pop.obj,[],1));
end

function parents = select_parents(pop, neighbors, problem)
    n_neighbors = numel(neighbors);
    parents = pop(neighbors(randperm(n_neighbors, problem.n_parent)),:);
end

function child = crossover(parents, weights, problem)
    child = struct();
    for i = 1:problem.n_var
        r = rand();
        if r <= 0.5
            child.var(i) = parents(1).var(i) + weights(i) * (parents(2).var(i) - parents(3).var(i));
        else
            child.var(i) = parents(1).var(i) + weights(i) * (parents(3).var(i) - parents(2).var(i));
        end
    end
end

function child = mutate(child, problem)
    for i = 1:problem.n_var
        r = rand();
        if r <= 1/problem.n_var
            child.var(i) = problem.var_range(i,1) + rand() * (problem.var_range(i,2) - problem.var_range(i,1));
        end
    end
end

function obj = evaluate_objective(individual, problem)
    obj = zeros(1, problem.n_obj);
    for i = 1:problem.n_obj
        obj(i) = problem.obj_funcs{i}(individual.var);
    end
end

function pop = update_population(pop, child, neighbors, weights, ref_point)
    for i = 1:numel(neighbors)
        j = neighbors(i);
        if dominates(child.obj, pop(j).obj)
            pop(j) = child;
        elseif dominates(pop(j).obj, child.obj)
            continue;
        else
            old_dist = sum(abs(pop(j).obj - ref_point));
            new_dist = sum(abs(child.obj - ref_point));
            if new_dist < old_dist
                pop(j) = child;
            end
        end
    end
end

function archive = update_archive(pop, archive, archive_size)
    n_archive = numel(archive);
    for i = 1:numel(pop)
        if dominates(pop(i).obj, archive)
            archive(n_archive+1) = pop(i);
            n_archive = n_archive + 1;
            if n_archive > archive_size
                [~, idx] = sort(arrayfun(@(x) sum(abs(x.obj)), archive));
                archive = archive(idx(1:archive_size));
                n_archive = archive_size;
            end
        elseif ~dominates(archive, pop(i).obj) && ~dominates(pop(i).obj, archive)
            [~, idx] = min(arrayfun(@(x) sum(abs(x.obj - pop(i).obj)), archive));
            archive(idx) = pop(i);
        end
    end
end

function result = dominates(obj1, obj2)
    result = all(obj1 <= obj2) && any(obj1 < obj2);
end