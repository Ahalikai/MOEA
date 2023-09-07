
% git pull origin master
% 
% git reset --hard HEAD^^
% git clean -df
% git status
% 
% git add .
% git commit -s
% git push origin master

% input_string = input("请输入姓名：", "s");
% disp("hello " + input_string)

format long
x = sin(pi / 8)

% clc
% clear

r1 = [1, 2, 3, 4, 5];
r2 = [6, 7, 8, 9, 0];
r3 = cat(1, r1, r2)
disp(r1 .* r2)

fprintf("%f\n", r2(3));

for i = 1 : length(r2)
    if r2(i) == 0
        disp("The " + string(i) + " number is zero.")
    else
        disp(r2(i))
    end
end

r3(2, 2 : 3)

names = {'ahalk', 'hello', 'sustech'};
names{1, 2 : 3}

for name = names
    if contains(name, 'lk')
        disp("OK")
    else
        disp("NO")
    end
end

a = mySort([4, 8, 1, 3, 8])

clc


power = @(x, n)






datetime

% function a = mySort(a)
%     len = length(a);
%     for i = 1: len - 1
%         for j = i + 1 : len
%             if a(i) > a(j)
%                 t = a(i);
%                 a(i) = a(j);
%                 a(j) = t;
%             end
%         end
%     end
% end