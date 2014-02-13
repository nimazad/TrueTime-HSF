clc
[r c] = size(VideoDecoder.data);
for i=2:r
    d(i) = VideoDecoder.data(i,1) - VideoDecoder.data(i-1,1);
end
max(d)
plot(d(1:r/4000))