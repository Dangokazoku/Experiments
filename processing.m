[file,path]=uigetfile('*.xlsx')
filepath = [path  file]
t1 = xlsread(filepath,'Sheet1','A3:A101');
t2 = xlsread(filepath,'Sheet1','C3:C101');
t3 = xlsread(filepath,'Sheet1','E3:E101');
l1 = xlsread(filepath,'Sheet1','B3:B101');
l2 = xlsread(filepath,'Sheet1','D3:D101');
l3 = xlsread(filepath,'Sheet1','F3:F101');
m_1 = readmatrix(filepath,'Sheet','Sheet1','Range','G3:G3');
m_2 = readmatrix(filepath,'Sheet','Sheet1','Range','H3:H3');
m_3 = readmatrix(filepath,'Sheet','Sheet1','Range','I3:I3');

syms n1;
r1 = t1(end);
r2 = t2(end);
r3 = t3(end);
a = 0;
b = 0;

p1 = polyfit(t1,l1,1);
fun1 = symfun(n1.*p1(1)+p1(2),[n1]);
n = fun1(r1);

while 1
    b = b+0.1;
    z = log(l2-b);
    p2 = polyfit(t2,z,1);
    fun2 = @(x) exp(x.*p2(1)+p2(2))+b;
    
    m = fun2(r1);
    if m > n
        break
    end
end
a = b-0.2;
for i=1:100
    c = (a+b)/2;
    z = log(l2-c);
    p2 = polyfit(t2,z,1);
    fun2 = @(x) exp(x.*p2(1)+p2(2))+c;
    
    m = fun2(r1);
    if m > n
        b = c;
    else
        a = c;
    end
end
fun2 = symfun(exp(n1.*p2(1)+p2(2))+c,[n1]);

p3 = polyfit(t3,l3,1);
fun3 = symfun(n1.*p3(1)+p3(2),[n1]);


Fun1 = fun1 - fun2;
Fun2 = fun3 - fun2;

a = r2-100;
b = r2+100;
for i=1:100
    c = (a+b)/2;
    x = Fun2(c);
    x = double(x);
    if x > 0
        b = c;
    else
        a = c;
    end
end
c1 = c;

f1 = int(Fun1);
f2 = int(Fun2);
Fun1 = f1 - f1(r1);
Fun2 = f2 - f2(c1);
f3 = Fun2 - Fun1;

first = figure('Name','积分相等点');
hold on;
fplot(f3,[r1,c1]);
a = r1;
b = c1;
for i=1:100
    c = (a+b)/2;
    x = double(f3(c));
    if x > 0
        a = c;
    else
        b = c;
    end
end
plot(c,0,'o');

txt = ['\leftarrow x = ', num2str(c)];
text(c,0,txt,"FontSize",27)

new = figure('Name','修正后冷却折线');
xlabel('t/s');
ylabel('T/°C');
hold on;
plot(t1,l1,'.');
plot(t2,l2,'.');
plot(t3,l3,'.');
fplot(fun1,[0,c]);
fplot(fun2,[r1,c1]);
fplot(fun3,[c,r3]);
xline(c);

T2_1 = fun1(r1);
T3_1 = fun2(c1);
T2 = fun1(c);
T3 = fun3(c);
T2 = double(T2);
T3 = double(T3);
T2_1 = double(T2_1);
T3_1 = double(T3_1);
M_1 = m_2 - m_1;
M_2 = m_3 - m_2;
L = (1/M_2)*(M_1*4.18+m_1*0.389)*(T2_1-T3_1)-4.18*T3_1-1.8*4;
L_1 = (1/M_2)*(M_1*4.18+m_1*0.389)*(T2-T3)-4.18*T3-1.8*4;

txt1 = ['竖直线：x = ',num2str(c),'' newline '' newline '修正后：T2'' = ',num2str(T2),' °C' newline '修正后：T3'' = ',num2str(T3),' °C' newline '' newline '修正前：L = ',num2str(L),' J/g' newline '修正后：L = ',num2str(L_1),' J/g'];
text(30,T3+9,txt1,"FontSize",24);
txt2 = '';
text(30,T3+0.1,txt2,"FontSize",18);

clear;