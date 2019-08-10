#import pip
#print(pip.pep425tags.get_supported())

# from PIL import Image
# image = Image.open('trump.png')
# resized =  image.resize((828, 1106))
# resized.save('trump.png')

import dlib
import numpy
import cv2

predictor_path = "./shape_predictor_68_face_landmarks.dat"
faces_path = "./hilary.png"
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(predictor_path)

window = dlib.image_window()
image = cv2.imread(faces_path)
window.clear_overlay()
window.set_image(image)


dets = detector(image, 1)
print("Number of faces detected: {}".format(len(dets)))

for k, d in enumerate(dets):
    print("dets{}".format(d))
    print("Detection {}: Left: {} Top: {} Right: {} Bottom: {}".format(
    k, d.left(), d.top(), d.right(), d.bottom()))
    shape = predictor(image, d)
    print("Part 0: {}, Part 1: {} ...".format(shape.part(0),  shape.part(1)))
    window.add_overlay(shape)
window.add_overlay(dets)


def get_landmarks(image_):
    rects = detector(image_, 1)
    return numpy.matrix([[p.x, p.y] for p in predictor(image_, rects[0]).parts()])

def get_landmarks_m(image_):

    dets = detector(image_, 1)

    print("Number of faces detected: {}".format(len(dets)))

    for i in range(len(dets)):

        facepoint = np.array([[p.x, p.y] for p in predictor(image_, dets[i]).parts()])

        for i in range(68):

            image_[facepoint[i][1]][facepoint[i][0]] = [232,28,8]        

    return image_    

print("face_landmark:")

print(get_landmarks(image))

dlib.hit_enter_to_continue()
numpy.savetxt('hilary.csv', get_landmarks(image), delimiter = ',')  