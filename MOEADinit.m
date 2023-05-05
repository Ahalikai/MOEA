% https://blog.csdn.net/qq_43472569/article/details/121457243

function MOEADinit()
    clc; clear;
    fun = input('knol, zdt1 ~ zdt4, zdt6, dtlz1/2:', 's');
    dimension = input('number of decision variables:');
    mop = testmop(fun, dimension);
    
    %种群规模 100， 方法 te
    %pareto = moead(mop, 'popsize', 100, 'niche', 20, 'iteration', 200, 'method', 'te');

end