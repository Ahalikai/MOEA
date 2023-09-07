
function a = mySort(a)
    a = mySort_max(a);
end

function a = mySort_max(a)
    len = length(a);
    for i = 1: len - 1
        for j = i + 1 : len
            if a(i) < a(j)
                t = a(i);
                a(i) = a(j);
                a(j) = t;
            end
        end
    end
end