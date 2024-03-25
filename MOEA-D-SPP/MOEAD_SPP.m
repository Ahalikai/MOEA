classdef MOEAD_SPP < ALGORITHM
% <multi/many> <real/binary/permutation>
% Multiobjective evolutionary algorithm based on decomposition
% type --- 1 --- The type of aggregation function

%------------------------------- Reference --------------------------------
% Q. Zhang and H. Li, MOEA/D: A multiobjective evolutionary algorithm based
% on decomposition, IEEE Transactions on Evolutionary Computation, 2007,
% 11(6): 712-731.
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Parameter setting
            type = Algorithm.ParameterSet(1);

            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            T = ceil(Problem.N/10);

            %% Detect the neighbours of each solution
            B = pdist2(W,W);
            [~,B] = sort(B,2);
            B = B(:,1:T);

            %% Generate random population
            Population = Problem.Initialization();
            Z = min(Population.objs,[],1);

            %% Ahalk nadir
            nadir = max(Population.objs,[],1);
            Zmax = nadir;
            delta_nadir = 0.1;
            count = 0;
            K = T + 1;
            alpha = 30;

            Ado_Flag = true;

            %% Optimization
            while Algorithm.NotTerminated(Population)
                % For each solution
                for i = 1 : Problem.N
                    % Choose the parents
                    P = B(i,randperm(size(B,2)));

                    % Generate an offspring
                    Offspring = OperatorGAhalf(Population(P(1:2)));

                    % Update the ideal point
                    Z = min(Z,Offspring.obj);


                    %% SPP
                    Proper = zeros(1, K);

                    if count > 300

                        % PBI approach
                        normW   = sqrt( repmat(sum(W(i,:).^2,2), Problem.N,1) );
                        normN   = sqrt(sum((Population.objs-repmat(Z,Problem.N,1)).^2,2));
                        CosineN = sum((Population.objs-repmat(Z,Problem.N,1)).*W(i,:),2)./normW./normN;
                        Detal2_all = normN.*sqrt(1-CosineN.^2);

                        [~,Detal2] = sort(Detal2_all);
                        Detal2 = Detal2(1: K - 1);
                        Detal2 = Detal2';

                        % T solutions closest to W(i,:) + Offspring
                        K_Nest = [Population(Detal2).objs; Offspring.obj];

                        % Get the PPO values of K solutions
                        Proper = zeros(1, K);

                        for j1 = 1 : K
                            for j2 = 1 : K
                                if j1 == j2
                                    continue;
                                end

                                Proper_new = abs( max(K_Nest(j1, :) - K_Nest(j2, :)) ) / abs( max(K_Nest(j2, :) - K_Nest(j1, :)) );
                                Proper(j1) = max(Proper(j1), Proper_new);
                            end
                        end

                        [~, Proper_rank] = sort(Proper);
                        aha = 2;

                        if Proper(K) > aha %2
                            continue;
                        end
                        if Proper_rank(K) == K
                            continue
                        end

                        alpha = 10.0 / (Problem.M - 2) +2


                        %%
                        if Proper(Proper_rank(K)) > alpha

                            Try_i = randi([1, K-1]);

                            while Proper(Try_i) > aha %2
                                if Try_i == 1
                                    break;
                                end
                                Try_i = randi([1, K-1]);
                            end
                            Population(Detal2(Proper_rank(K))) = Population(Detal2(Try_i));

                        end
                    end

                    %% Adaptive_Weights

                    if count == 600
                        if Ado_Flag

                            % Fit PF shape
                            PopObj = Population.objs;
                            CP = [2/7,2/6,2/5,2/4,2/3,2/2,2/1,2/(1.3),2/0.5];
                            VP = zeros(length(CP),1);
                            GP = zeros(size(PopObj,1),1);
                            for ii = 1:length(CP)
                                p = CP(ii);
                                for j = 1:size(PopObj,1)
                                    x = PopObj(j,:);
                                    GP(j) = (sum((1-x).^p)).^(1/p);
%                                     GP(j) = (sum((x).^p)).^(1/p);
                                end
                                VP(ii) = std(GP);
                            end
                            [~,index] = min(VP);
                            p = CP(index);

                            % Produce sufficiently uniformly distributed direction vectors
                            R = UniformPoint(10000,size(PopObj,2));
                            R = 1-(R.^(1/p));
%                             R = (R.^(1/p));
                            [~,Index] = min(R);
                            corner_set = R(Index,:);
                            R_rest = setdiff(R,corner_set,'rows');
                            Combine = [corner_set;R_rest];
                            Selected = false(1,length(Combine));
                            Selected(1:size(corner_set,1)) = true;
                            Dis = pdist2(Combine,Combine);
                            while sum(Selected) < Problem.N
                                [~,rho] = max(min(Dis(~Selected,Selected),[],2));
                                Remain = find(~Selected);
                                Selected(Remain(rho)) = true;
                            end
                            W = Combine(Selected,:);
                            W = W./sum(W,2);
                            for ii = 1:size(PopObj,2)
                                W(ii,ii) = 1e-6;
                            end


                            Ado_Flag = false;
                        end
                    end


                    % Update the neighbours
                    switch type
                        case 1
                            % PBI approach
                            normW   = sqrt(sum(W(P,:).^2,2));
                            normP   = sqrt(sum((Population(P).objs-repmat(Z,T,1)).^2,2));
                            normO   = sqrt(sum((Offspring.obj-Z).^2,2));
                            CosineP = sum((Population(P).objs-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
                            CosineO = sum(repmat(Offspring.obj-Z,T,1).*W(P,:),2)./normW./normO;
                            g_old   = normP.*CosineP + 10*normP.*sqrt(1-CosineP.^2);
                            g_new   = normO.*CosineO + 10*normO.*sqrt(1-CosineO.^2);
                        case 2
                            % Tchebycheff approach
                            g_old = max(abs(Population(P).objs-repmat(Z,T,1)).*W(P,:),[],2);
                            g_new = max(repmat(abs(Offspring.obj-Z),T,1).*W(P,:),[],2);
                        case 3
                            % Tchebycheff approach with normalization
                            Zmax  = max(Population.objs,[],1);
                            g_old = max(abs(Population(P).objs-repmat(Z,T,1))./repmat(Zmax-Z,T,1).*W(P,:),[],2);
                            g_new = max(repmat(abs(Offspring.obj-Z)./(Zmax-Z),T,1).*W(P,:),[],2);
                        case 4
                            % Modified Tchebycheff approach
                            g_old = max(abs(Population(P).objs-repmat(Z,T,1))./W(P,:),[],2);
                            g_new = max(repmat(abs(Offspring.obj-Z),T,1)./W(P,:),[],2);
                    end

                    Population(P(g_old>=g_new)) = Offspring;

                end

                %% Stability Measure
                nadir = max(Population.objs,[],1);

                if (sum(abs(Zmax-nadir)./nadir)/Problem.M) <= delta_nadir
                    count = count + 1
                else
                    count = max(0, count - 1);
                    disp(sum(abs(Zmax-nadir)./nadir)/Problem.M)
                end
%                 disp(sum(abs(Zmax-nadir)./nadir)/Problem.M);
%                 Zmax = min(Zmax, nadir)
                Zmax = nadir;
               

            end
        end
    end
end