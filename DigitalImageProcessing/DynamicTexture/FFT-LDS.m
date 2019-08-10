close all;
clear;clc;
all_images = dir('Data\all\candle-4\');
cd('Data\all\candle-4\')
image_0 = imread(all_images(3).name);
cd('..\..\..\');

[row, column, channel] = size(image_0);

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
        image= double(rgb2gray(image));
    end
    image_fft = fft2(image);
    Y_fft(:, :, k-2) = image_fft(:);
    Y_gray(:, k-2) = image(:);
end

Thr = 90; 
n_fft_rgb_vec = 30;
tau = length(all_images) - 2;

Y_fft_gray = Y_fft(1: row*column, :);

thr_gray = 0;     
pp = Thr;
Mask_gray = ones(size(Y_fft_gray(:, 1)));    
while(pp < nnz(Mask_gray) / numel(Mask_gray) * 100)
    thr_gray = thr_gray + 1;
    for j = 1:tau
        Mask_gray = Mask_gray & (abs(Y_fft_gray(:, j)) > thr_gray);
    end
end    
th_gray_vec = thr_gray;

thr_gray = th_gray_vec(1);
Mask_gray = ones(size(Y_fft_gray(:,1)));

for i = 1:tau
    Mask_gray = Mask_gray & (abs(Y_fft_gray(:,i)) > thr_gray);
end
pos_gray = find(Mask_gray);
L_gray = length(pos_gray);

Y_fft_masked_gray = Y_fft_gray(pos_gray,:);
Y_SVD_gray(1:L_gray, :) = real(Y_fft_masked_gray);
Y_SVD_gray(L_gray+1:2*L_gray, :) = imag(Y_fft_masked_gray);

Y_SVD_Mean = mean(Y_SVD_gray, 2);
[U,S,V] = svd(Y_SVD_gray - Y_SVD_Mean * ones(1, size(Y_SVD_gray,2)), 0);            

              
n_fft = n_fft_rgb_vec;     
nv_fft = round(n_fft / 3 * 2);
first = 1:n_fft;
Chat = U(:, first); 
Xhat = S(first, first) * V(:, first)';
Ahat = Xhat(:, 2:tau) * pinv(Xhat(:, 1:tau - 1));
Vhat = Xhat(:, 2:tau) - Ahat * Xhat(:, 1:(tau - 1));
[Uv, Sv, Vv] = svd(Vhat, 0);
Bhat = Uv(:, 1:n_fft_rgb_vec) * Sv(1:n_fft_rgb_vec, 1:n_fft_rgb_vec);

X(:,1) = Xhat(:,150);
j = sqrt(-1);

result_length = 500;
result = VideoWriter('candle4.avi');
open(result);

for t = 1:result_length
    X(:,t+1) = Ahat * X(:,t) + Bhat*randn(n_fft_rgb_vec, 1); 
    Y_res = Chat*X(:, t) + Y_SVD_Mean;

    Y_real_gray = Y_res(1:L_gray);
    Y_imag_gray = Y_res(L_gray + 1:2*L_gray);    
	Y_fft_result = zeros(row * column,1);
    temp_gray = Y_real_gray + j * Y_imag_gray;
    Y_fft_result(pos_gray) = temp_gray;        
    Y_result_gray = real(ifft2(reshape(Y_fft_result, row, column)));    
    Y_gray_synth(:,:,1) = Y_result_gray;
    
    Y_gray_result = uint8(floor((Y_gray_synth - floor(min(Y_gray_synth(:))))./(ceil(max(Y_gray_synth(:)))-floor(min(Y_gray_synth(:))))*255));
    imshow(Y_gray_result);
    frame = getframe;
    writeVideo(result, frame);
    title(strcat('Frame ', num2str(t)));
    pause(0.01);
end

close(result);