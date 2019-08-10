close all;
clear;clc;
all_images = dir('Data\all\candle-4\');
cd('Data\all\candle-4\')
image_0 = imread(all_images(3).name);
cd('..\..\..\');

[row, column, channel] = size(image_0);
Y = zeros(row * column, length(all_images)-2);

if (channel == 3)
    is_color = 1;
else
    is_color = 0;
end

for k = 3:length(all_images)
    file_name = all_images(k).name;
    cd('Data\all\candle-4\')
    image = imread(file_name);
    cd('..\..\..\');
    
    if (is_color)
        image= rgb2gray(image);
    end
    Y(:, k-2) = double(reshape(image, row * column, 1));
end

Ymean = mean(Y, 2);
[U, S, V] = svd(Y - Ymean * ones(1, size(Y, 2)), 0);

n = 50;
nv = 20;

Chat = U(:, 1:n);
Xhat = S(1:n, 1:n) * V(:, 1:n)';
Ahat = Xhat(:, 2:size(Y, 2)) * pinv(Xhat(:, 1:(size(Y, 2)-1)));
Vhat = Xhat(:, 2:size(Y, 2)) - Ahat * Xhat(:, 1:(size(Y, 2)-1));
[Uv,Sv,Vv] = svd(Vhat, 0);
Bhat = Uv(:, 1:nv) * Sv(1:nv, 1:nv);

% Generate new frames using the last frame of training sample as the initial frame
X(:,1) = Xhat(:, 150);
result_length = 2000;

result = VideoWriter('candle4.avi');
open(result);

for t = 1:result_length
   X(:, t+1) = Ahat * X(:,t) + Bhat * randn(nv,1);
   I = Chat*X(:,t) + Ymean;
   I = floor(I);
   
   imshow(reshape(I, row, column), [0,255]);
   frame = getframe;
   writeVideo(result, frame); 
   title(strcat('Frame ', num2str(t)));
   pause(0.01);
end

close(result);




