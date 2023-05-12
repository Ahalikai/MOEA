function demo()
    mop = testmop('zdt1', 30);

    pareto = moead(mop, 'popsize', 100, 'niche', 20, 'iteration', 200, 'method', 'te');
end