
% https://blog.csdn.net/qq_43472569/article/details/121457243
function demo()
    mop = testmop('zdt1', 30);

    pareto = moead(mop, 'popsize', 100, 'niche', 20, 'iteration', 200, 'method', 'te');
end