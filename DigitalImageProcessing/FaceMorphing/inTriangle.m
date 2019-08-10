% this function is to solve whether a point (x, y) is in the given triangle
% x0, y0, x1, y1, x2, y2 are the vertexes of the given triangle
% to solve this problem is to solve the following equation group

% w0 * x0 + w1 * x1 + w2 * x2 = x
% w0 * y0 + w1 * y1 + w2 * y2 = y
% w0 + w1 + w2 = 1

% if the point is in the triangel, we have 
% (w0 >= 0) & (w1 >= 0) & (w2 >= 0) & (w0 <= 1) & (w1 <= 1) & (w2 <= 1)

function [w0, w1, w2, in] = inTriangle(x, y, x0, y0, x1, y1, x2, y2)
    x0 = repmat(x0, size(x,1), size(x,2));
    y0 = repmat(y0, size(x,1), size(x,2));
    x1 = repmat(x1, size(x,1), size(x,2));
    y1 = repmat(y1, size(x,1), size(x,2));
    x2 = repmat(x2, size(x,1), size(x,2));
    y2 = repmat(y2, size(x,1), size(x,2));

    w0 = ((x - x2) .* (y1 - y2) - (y - y2) .* (x1 - x2)) ./ ((x0 - x2) .* (y1 - y2) - (y0 - y2) .* (x1 - x2) + eps);

    w1 = ((x - x2) .* (y0 - y2) - (y - y2) .* (x0 - x2)) ./ ((x1 - x2) .* (y0 - y2) - (y1 - y2) .* (x0 - x2) + eps);
    w2 = 1 - w0 - w1;
    in = (w0 >= 0) & (w1 >= 0) & (w2 >= 0) & (w0 <= 1) & (w1 <= 1) & (w2 <= 1);
end