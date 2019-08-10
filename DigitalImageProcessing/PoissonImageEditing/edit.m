% Poisson Image Editing
% 
% parameters
% Source -- source image
% Target -- destination image
% Mask   -- Mask image
% box    -- the rectangular box for the selection in source, [x0 x1 y0 y1]
% position 
%        -- the upper left corner of the source should go to this position in the destination image [x0 y0]
% Result -- the file to save the result image

function edit(Source, Target, Mask, box, position, Result)
    targetImage = double(imread(Target));
    insertImage = double(imread(Source));
    maskImage = uint8(imread(Mask));
    figure(1);
    imshow(imread(Source))
    %imshow(imread(Target))
    
    t=tic;

    targetR = targetImage(:, :, 1);
    targetG = targetImage(:, :, 2);
    targetB = targetImage(:, :, 3);

    insertR = insertImage(:, :, 1);
    insertG = insertImage(:, :, 2);
    insertB = insertImage(:, :, 3);

    resultR = PoissonSolver(insertR, targetR, box, position, maskImage);
    resultG = PoissonSolver(insertG, targetG, box, position, maskImage);
    resultB = PoissonSolver(insertB, targetB, box, position, maskImage);

    [heightR, widthR] = size(resultR);

    resultImage = zeros(heightR, widthR, 3);
    resultImage(:, :, 1) = resultR;
    resultImage(:, :, 2) = resultG;
    resultImage(:, :, 3) = resultB;

    toc(t);
    resultImage = uint8(resultImage);
    figure(2);
    imshow(resultImage);
    imwrite(resultImage, Result);
end