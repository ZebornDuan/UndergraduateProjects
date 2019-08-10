function Gamma(value)
f = imread('index.jpg');
subplot(211), imshow(f);
[n, m, h] = size(f);
for i = 1:n
    for j = 1:m
        for k = 1:h
            f(i, j, k) = uint8(round(255 * (double(f(i, j, k)) / 255.0) ^ (1.0 / value)));
        end
    end
end
subplot(212), imshow(f);
imwrite(f, 'ChangeGamma.jpg')