function contrast(value)
f = imread('index.jpg');
subplot(211), imshow(f);
[n, m, h] = size(f);
for i = 1:n
    for j = 1:m
        for k = 1:h
            f(i, j, k) = round(max(min(255, (f(i, j, k) - 127) * value + 127), 0));
        end
    end
end
subplot(212), imshow(f);
imwrite(f, 'ChangeContrast.jpg')