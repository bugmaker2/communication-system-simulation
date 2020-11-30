clc
clear
[signal,fs] = audioread('bluesky1.wav');    %读取音频文件，fs为采样率，s为16位量化后的离散信号
t=(0:length(signal)-1)/fs;                  %通过采样率生成t轴坐标

%将信号处理为4-12位
for i=1:9
    s(:,i)=signal.*((2^(i+2))*10)./3;       %变换幅度轴的尺度，以便于后续用round函数做处理
    s(:,i)=round(s(:,i));                   %round函数做四舍五入
    s(:,i)=s(:,i).*3./((2^(i+2))*10);       %还原幅度轴的尺度
end

figure
plot(t,signal)                              %绘制波形图
title('原信号波形图')
xlabel('时间(sec)')                   
ylabel('幅度')

figure
plot(t,s(:,1))     
title('4位量化信号波形图')
xlabel('时间(sec)')                   
ylabel('幅度')

figure
plot(t,s(:,3))       
title('6位量化信号波形图')
xlabel('时间(sec)')                   
ylabel('幅度')

figure
plot(t,s(:,5))     
title('8位量化信号波形图')
xlabel('时间(sec)')                   
ylabel('幅度')

%计算均方误差
for i=1:9
    e(:,i)=(signal-s(:,i)).^2;              %计算误差
    err(i)=sum(e(:,i))/32000;               %计算均方误差
end
n=4:12;

figure
plot(n,err)
axis([3 13 -0.00001 0.00008]) 
title('均方误差与量化位数n的关系')
xlabel('量化位数n')                   
ylabel('均方误差')

%计算误码率
a=rms(signal);                              %原信号的有效值（方均根）
b=a./err;                                   %计算误码率
b=10*log10(b);                              %取对数

figure
plot(n,b)
axis([3 13 25 80]) 
title('信噪比与量化位数n的关系')
xlabel('量化位数n')                   
ylabel('信噪比')


sound(signal,fs);                       %播放音频
pause(4);                               %暂停4秒
sound(s(:,1),fs);                       
pause(4);                               
sound(s(:,3),fs);                       
pause(4);                               
sound(s(:,5),fs);           
