# Face Morphing

## how to run the codes

1. run python feature.py to generate the feature point and save it in a csv file.

You need to change the image path, the trained model path and the result file name in the code. The two source images should have the same size. If not, uncomment the first part of the code to resize them into the same size.

You can use any other API to finish the image read and resize. In the code, the PIL and cv2 are used, however, you can replace them with other packages providing such APIs like matplotlib, sklearn...

2. call faceMorphing.m in Matlab. The parameters are explained in the code. You can call
faceMorphing('hilary.png', 'cruz.png', 'hilary.csv', 'cruz.csv') to get the sample result.

## get feature points

dlib packake for python are used to get the feature points.

dlib for python can be easily installed through [the wheel](https://pypi.python.org/pypi/dlib/18.17.100#downloads). The trained face feature detection model can be downloaded [here](https://zh.osdn.net/projects/sfnet_dclib/downloads/dlib/v18.10/shape_predictor_68_face_landmarks.dat.bz2/). Remember to change the model path on your machine in the code.

## sample

sources

![cruz](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/DigitalImageProcessing/FaceMorphing/cruz.png)

![trump](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/DigitalImageProcessing/FaceMorphing/trump.png)

![hilary](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/DigitalImageProcessing/FaceMorphing/hilary.png)

results:

![cruz-hilary](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/DigitalImageProcessing/FaceMorphing/result1.png)

![cruz-trump](https://github.com/ZebornDuan/UndergraduateProjects/blob/master/DigitalImageProcessing/FaceMorphing/result2.png)

## algorithm

- The point correspondences across two images are averaged, giving an average face.  Delauney triangulation is then performed on these points, sectioning the plane into triangles.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/22136934/20359373/89a8e934-abfd-11e6-854d-070eb894a3cb.jpg" width="650">
</p>

- These triangles computed in the average face can be applied to the points in each of the original faces (inversed wrapping). To finish this we need to solve a equation group (see in in the inTriangle.m).

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/22136934/20367661/770dee70-ac1e-11e6-9368-c25225e5082c.jpg" width="650">
</p>

- Use image interpolation to generate the final image.

## more about this problem

[face swap in python](https://github.com/matthewearl/faceswap)

[face swap in C++](https://github.com/iamwx/faceSwap)

[face morphing video](https://github.com/sschloesser/ImageMorphing)