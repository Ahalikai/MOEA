
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
clear

H1 = 5; M = 3;

W1 = nchoosek(1:H1+M-1,M-1)
size(W1 , 1)
W2 = repmat(0:M-2,nchoosek(H1+M-1,M-1),1)
size(W2 , 1)
W = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1
% size(W , 1)
[W,zeros(size(W,1),1)+H1]
[zeros(size(W,1),1),W]
([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])
W = ([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])

N = size(W,1)
T = ceil(N/10)

B = pdist2(W, W)
[~,B] = sort(B,2)
B = B(:,1:T)

% clc
% clear

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