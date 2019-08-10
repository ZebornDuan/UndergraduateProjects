function morphing(image1, image2, feature1, feature2)
    source1 = imread(image1);
    source2 = imread(image2);

    height1 = size(source1, 1);
    width1 = size(source1, 2);

    height2 = size(source2, 1);
    width2 = size(source2, 2);

    m1 = csvread(feature1);
    m1 = reshape(m1, 68, 2);
    x1 = m1(:, 1);
    y1 = m1(:, 2);

    m2 = csvread(feature2);
    m2 = reshape(m2, 68, 2);
    x2 = m2(:, 1);
    y2 = m2(:, 2);

    % add the corner points to the feature points
    x1 = [x1; 1; width1; width1; 1]; % size(xA) = [72, 1]
    y1 = [y1; 1; 1; height1; height1];
    x2 = [x2; 1; width2; width2; 1];
    y2 = [y2; 1; 1; height2; height2];

    m1 = [x1 y1];
    m2 = [x2 y2];

    morph(source1, source2, m1, m2, 0.5, 0.5);
end

function morphed_image = morph(picture1, picture2, feature_points1, feature_points2, warp_fraction, dissolve_fraction)
    average_feature = (feature_points1 + feature_points2) / 2;
    triangles = delaunay(average_feature);
    wrap_points = (1 - warp_fraction) * feature_points1 + warp_fraction * feature_points2;
    [I, J] = meshgrid(1 : (size(picture1, 2)), 1 : (size(picture1, 1)));
    I = reshape(I, [(size(I, 1) * size(I, 2)) 1]);
    J = reshape(J, [(size(J, 1) * size(J, 2)) 1]);
    Coordinates = horzcat(I, J);
        
    t = tsearchn(wrap_points, triangles, Coordinates);
    Points = [];

    for t_index = 1 : size(triangles, 1)
        A = [wrap_points(triangles(t_index, 1), 1) wrap_points(triangles(t_index, 2), 1) wrap_points(triangles(t_index, 3), 1);
             wrap_points(triangles(t_index, 1), 2) wrap_points(triangles(t_index, 2), 2) wrap_points(triangles(t_index, 3), 2);
             1 1 1];
        
        inverse_A = inv(A);

        InTriangle = Coordinates(t == t_index, :);
                
        PointNumber = size(InTriangle, 1);
        
        InTriangle = horzcat(InTriangle, ones(size(InTriangle, 1), 1));
        
        inverse_A1   = inverse_A(1, :);
        inverse_A2   = inverse_A(2, :);
        inverse_A3 = inverse_A(3, :);

        bariX = (inverse_A1 * InTriangle')';
        bariY = (inverse_A2 * InTriangle')';
        bariZ = (inverse_A3 * InTriangle')';
        
        PointsAddition = horzcat(t_index * ones(PointNumber, 1), InTriangle(:, 1), InTriangle(:, 2), bariX, bariY, bariZ); 
        Points = vertcat(Points, PointsAddition);  
    end 
    PointsSource1 = [];
    PointsSource2 = [];
    
    for t_index =  1 : size(triangles, 1)
        A1 = [feature_points1(triangles(t_index, 1), 1) feature_points1(triangles(t_index, 2), 1) feature_points1(triangles(t_index, 3), 1);
              feature_points1(triangles(t_index, 1), 2) feature_points1(triangles(t_index, 2), 2) feature_points1(triangles(t_index, 3), 2);
              1 1 1];
          
        A2 = [feature_points2(triangles(t_index, 1), 1) feature_points2(triangles(t_index, 2), 1) feature_points2(triangles(t_index, 3), 1);
              feature_points2(triangles(t_index, 1), 2) feature_points2(triangles(t_index, 2), 2) feature_points2(triangles(t_index, 3), 2);
              1 1 1];
         
        try
            info = Points(Points(:,1) == t_index, 2:6);
        catch
            disp('Exception caught');
            continue;
        end
        
        bari = info(:, 3:5);
        
        pixelPoints1 = (A1 * bari')';
        pixelPoints1 = pixelPoints1 ./ repmat(pixelPoints1(:, 3), [1 3]);
        
        PointsSource1 = vertcat(PointsSource1, horzcat(pixelPoints1(:, 1), pixelPoints1(:, 2), info(:, 1), info(:, 2)));
        
        pixelPoints2 = (A2 * bari')';
        pixelPoints2 = pixelPoints2 ./ repmat(pixelPoints2(:, 3), [1 3]);
        
        PointsSource2 = vertcat(PointsSource2, horzcat(pixelPoints2(:, 1), pixelPoints2(:, 2), info(:, 1), info(:, 2))); 
    end
    morphedImage1  = zeros(size(picture1, 1), size(picture1, 2), 3);
    
    jSource = round(PointsSource1(:, 1));
    iSource = round(PointsSource1(:, 2));
    jTarget = round(PointsSource1(:, 3));
    iTarget = round(PointsSource1(:, 4));

    height_1 = size(picture1, 1);
    width_1 = size(picture1, 2);
        
    iSource(iSource < 1)    = 1;
    iSource(iSource > height_1) = height_1;
    jSource(jSource < 1)    = 1;
    jSource(jSource > width_1) = width_1;
     
    iTarget(iTarget < 1)    = 1;
    iTarget(iTarget > height_1) = height_1;
    jSource(jSource < 1)    = 1;
    jTarget(jTarget > width_1) = width_1;
 
    for i = 1 : size(PointsSource1, 1)
        morphedImage1(iTarget(i), jTarget(i), :) = picture1(iSource(i), jSource(i), :);
    end

    morphedImage2 = zeros(size(picture1, 1), size(picture1, 2), 3);
    
    jSource = round(PointsSource2(:, 1));
    iSource = round(PointsSource2(:, 2));
    jTarget = round(PointsSource2(:, 3));
    iTarget = round(PointsSource2(:, 4));
    
    height_2 = size(picture2, 1);
    width_2 = size(picture2, 2);
        
    iSource(iSource < 1) = 1;
    iSource(iSource > height_2) = height_2;
    jSource(jSource < 1) = 1;
    jSource(jSource > width_2) = width_2;
     
    iTarget(iTarget < 1) = 1;
    iTarget(iTarget > height_2) = height_2;
    jSource(jSource < 1) = 1;
    jTarget(jTarget > width_2) = width_2;
    
    for i = 1 : size(PointsSource2, 1)
        morphedImage2(iTarget(i), jTarget(i), :) = picture2(iSource(i), jSource(i), :);
    end
    dissolvedImage = (1 - dissolve_fraction) * morphedImage1 + dissolve_fraction * morphedImage2;
    morphed_image = uint8(dissolvedImage);
    imshow(morphed_image);
    imwrite(morphed_image, 'result2.png');
end
