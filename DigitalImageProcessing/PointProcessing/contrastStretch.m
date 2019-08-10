function contrastStretch(v1, v2)
f = imread('index.jpg');
subplot(211), imshow(f);
[n, m, h] = size(f);
t1 = [255 255 255];
t2 = [0 0 0];
for i = 1:n
    for j = 1:m
        for k = 1:h
            if f(i, j, k) < t1(k)
                t1(k) = f(i, j, k);
            end
            if f(i, j, k) > t2(k)
                t2(k) = f(i, j, k);
            end
        end
    end
end

for i = 1:n
    for j = 1:m
        for k = 1:h
            f(i, j, k) = uint8(round((v2(k) - v1(k)) * double(f(i, j, k) - t1(k)) / (t2(k) - t1(k)) + v1(k)));
        end
    end
end
            
subplot(212), imshow(f);
imwrite(f, 'constrastStretch.jpg')