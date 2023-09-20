
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

clc
clear

datetime


clc,clear
L1=[0,0;0,200]; 
plot(L1(:,1),L1(:,2));hold on 
% text(0,4,'x_1=0','color','b');

L2=[0,0;200,0]; 
plot(L2(:,1),L2(:,2));hold on
% text(4,0,'x_2=0','color','b');

L3=[0,120;60,0]; 
plot(L3(:,1),L3(:,2), 'Linewidth', 3);hold on
text(0,120,'10x_1+5x_2=600','color','b');

L4=[0,30;100,0]; 
plot(L4(:,1),L4(:,2), 'Linewidth', 3);hold on
text(100,0,'6x_1+20x_2=600','color','b');

L5=[0,60;600/8,0]
plot(L5(:,1),L5(:,2), 'Linewidth', 3);hold on
text(0,60,'8x_1+10x_2=600','color','b');

% x=[0 0 1 4 2]'; 
% y=[0 2 4 1 0]'; 
% fill(x,y,'r'); 

xlabel('x_1')
ylabel('x_2')

a=(53*20+13*30)


% z0=[0,30;20,0]; 
% plot(z0(:,1),z0(:,2),'k--','LineWidth',2);
% text(4,1,'z=-3')
% 
% z1=[2,0;3.5,1.5]; 
% plot(z1(:,1),z1(:,2),'k--','LineWidth',2);
% text(3.5,1.5,'z=-2')
% 
% z2=[0,0;2.5,2.5]; 
% plot(z2(:,1),z2(:,2),'k--','LineWidth',2);
% text(2.5,2.5,'z=0')
% 
% z3=[0,2;1.5,3.5]; 
% plot(z3(:,1),z3(:,2),'k--','LineWidth',2);
% text(1.5,3.5,'z=2')
% 
% z4=[0,3;1,4]; 
% plot(z4(:,1),z4(:,2),'k--','LineWidth',2);
% text(0,3,'z=3')

% text(1,4,'X','color','r','fontsize',20);

% c = [20; 30];
% b = [600; 600; 600];
% a = [10, 5; 6, 20; 8, 10];
% lb = zeros(2, 1);
% [x, fval] = linprog(-c, a, b, [], [], lb)
% y = -fval


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