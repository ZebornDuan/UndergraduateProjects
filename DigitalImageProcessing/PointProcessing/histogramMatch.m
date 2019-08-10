function histogramMatch(channel)
f = imread('index.jpg');
g = imread('index2.jpg');
subplot(311), imshow(f);
subplot(312), imshow(g);
[n, m, h] = size(f);
% calculate the histogram
h0 = zeros(3, 256);
h1 = zeros(3, 256);
for i = 1:n
    for j = 1:m
        for k = 1:h
            h0(k, f(i, j, k) + 1) = h0(k, f(i, j, k) + 1) + 1;
            h1(k, g(i, j, k) + 1) = h1(k, g(i, j, k) + 1) + 1;
        end
    end
end

% calculate cummulative histogram
for k = 1:3
    for i = 2:256
        h0(k, i) = h0(k, i - 1) + h0(k, i);
        h1(k, i) = h1(k, i - 1) + h1(k, i);
    end
end

for k = 1:3
    for i = 1:256
        h0(k, i) = double(h0(k, i)) / double(h0(k, 256));
        h1(k, i) = double(h1(k, i)) / double(h1(k, 256));
    end
end

for k = 1:size(channel)
    index = 0;
    for i = 1:256
        while h0(channel(k) + 1, i) >= h1(channel(k) + 1, index + 1) && index < 255
            index = index + 1;
        end
        h0(channel(k) + 1, i) = index;
    end
end
    
for i = 1:n
    for j = 1:m
        for k = 1:size(channel)
            f(i, j, channel(k) + 1) = h0(channel(k) + 1, f(i, j, channel(k) + 1) + 1);
        end
    end
end

subplot(313), imshow(f);
imwrite(f, 'histogramMatch.jpg');

