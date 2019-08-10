function [result] = PoissonSolver(insert, target, box, position, Mask)

%
% rectangular solver
% 
% parameters
% insert - source image
% target - destination image
% box    - the rectangular box for the selection in source, [x0 x1 y0 y1]
% position 
%        - the upper left corner of the source should go to this position in the destination image [x0 y0]
% Mask   - source mask


% laplace convolutional kernal
% calculate the div
laplacian = [0 1 0; 1 -4 1; 0 1 0];

MASK_HANDLE_REGION = 128;

[heightS, widthS] = size(insert);
[heightT, widthT] = size(target);

x0s = 1;
x1s = box(2);
y0s = 1;
y1s = box(4);

xOffset = box(1);
yOffset = box(3);

x0d = position(1) - 1;
y0d = position(2) - 1;

heightRegion = y1s - y0s + 1;
widthRegion = x1s - x0s + 1;

% check the range
if x1s >= widthS || y1s >= heightS || x0d < 1 || y0d < 1
    fprintf('Error - box too large!\n');
end

if y0d > heightT || x0d > widthT
    fprintf('Error - target position out of rigion');
end

n = 1;
PointIndex = 0;

PointMap = containers.Map(0, 0);
for y = yOffset:heightRegion
    for x = xOffset:widthRegion
        if Mask(y, x) > MASK_HANDLE_REGION
            PointIndex = (y - 1) * widthRegion + x;
            PointMap(PointIndex) = n;
            n = n + 1;
        end
    end
end

n = n - 1;
% sparse matrix
M = spalloc(n, n, 5 * n);
b = zeros(1, n);

% get the div
LaplacianT = conv2(insert, -laplacian, 'same');

count = 1;
index = 0;

% replace the div with that in the souce in inner area
% the border pixels give the constrain

for y = yOffset:heightRegion
    for x = xOffset:widthRegion
        % not in the mask area
        if Mask(y, x) <= MASK_HANDLE_REGION
            continue;
        end

        PointIndex = (y - 1) * widthRegion + x;      

        offsetY = y - yOffset;
        offsetX = x - xOffset;
        
        % top border
        if y == 1 || Mask(y - 1, x) <= MASK_HANDLE_REGION
            b(count) = b(count) + target(offsetY + y0d - 1, offsetX + x0d);
        else
            index = PointMap(PointIndex - widthRegion);
            M(count, index) = -1;
        end

        % bottom border
        if y == heightRegion || Mask(y + 1, x) <= MASK_HANDLE_REGION
            b(count) = b(count) + target(offsetY + y0d + 1, offsetX + x0d);
        else
            index = PointMap(PointIndex + widthRegion);
            M(count, index) = -1;
        end
    
        %left border
        if x == 1 || Mask(y,x - 1) <= MASK_HANDLE_REGION
            b(count) = b(count) + target(offsetY + y0d, offsetX + x0d - 1);
        else
            index = PointMap(PointIndex - 1);
            M(count, index) = -1;
        end
        
        % right border
        if x == widthRegion || Mask(y, x + 1) <= MASK_HANDLE_REGION
             b(count) = b(count) + target(offsetY + y0d, offsetX + x0d + 1);
        else
            index = PointMap(PointIndex + 1);
            M(count, index) = -1;
        end

        index = PointMap(PointIndex);
        M(count, index) = 4;

        div = LaplacianT(y, x);
        b(count) = b(count) + div;

        count = count + 1; 
    end
end

% solve the equation group
X = bicg(M, b', [], 400);

result = target;
n = 1;

for y = yOffset:heightRegion
    for x = xOffset:widthRegion
        if(Mask(y, x) > MASK_HANDLE_REGION)
            result(y + y0d - yOffset, x + x0d - xOffset) = X(n);
            n = n + 1;
        end
    end
end
