close 
clc
VideoDecoder = importdata(strcat(pwd,'\alloallo1.txt'))
[r c] =  size(VideoDecoder.data);
VideoDecoder.data = VideoDecoder.data./1000;
%%
numberOfFrames = 150;%r;
plot(VideoDecoder.data([1:numberOfFrames],2),'-k.')
hold on
plot(VideoDecoder.data([1:numberOfFrames],1),'-b*')
xlabel('Frame number');
ylabel('Execution time (ms)');
%%
subplot(4,1,1);
plot(VideoDecoder.data([1:numberOfFrames],1),'.')
hold on
subplot(4,1,2);
plot(VideoDecoder.data([1:numberOfFrames],2),'r.')
hold on
subplot(4,1,3);
plot(VideoDecoder.data([1:numberOfFrames],3),'k.')
hold on
subplot(4,1,4);
plot(VideoDecoder.data([1:numberOfFrames],4),'g.')

for i=1:4
minEx(i) = min(VideoDecoder.data(:,i));
maxEx(i) = max(VideoDecoder.data(:,i));
meanEx(i) = mean(VideoDecoder.data(:,i));
end
disp('    ----Min----');
disp(minEx)
disp('    ----Max----');
disp(maxEx)
disp('    ----Mean----');
disp(meanEx)