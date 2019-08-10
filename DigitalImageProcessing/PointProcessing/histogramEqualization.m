function histogramEqualization(channel)
f = imread('index.jpg');
subplot(211), imshow(f);
[n, m, h] = size(f);
% calculate the histogram
h0 = zeros(3, 256);
for i = 1:n
    for j = 1:m
        for k = 1:h
            h0(k, f(i, j, k) + 1) = h0(k, f(i, j, k) + 1) + 1;
        end
    end
end

% calculate cummulative histogram
for k = 1:3
    for i = 2:256
        h0(k, i) = h0(k, i - 1) + h0(k, i);
    end
end

for k = 1:3
    for i = 1:256
        h0(k, i) = double(h0(k, i)) / double(h0(k, 256));
    end
end

for i = 1:n
    for j = 1:m
        for k = 1:size(channel)
            f(i, j, channel(k) + 1) = uint8(round(255 * h0(k, f(i, j, channel(k) + 1) + 1)));
        end
    end
end

subplot(212), imshow(f);
imwrite(f, 'histogramEqualization.jpg');

