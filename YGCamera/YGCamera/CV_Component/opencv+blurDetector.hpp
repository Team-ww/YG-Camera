
#ifndef OPENCV_ALL_HPP
#define OPENCV_ALL_HPP

#include "opencv2/opencv_modules.hpp"

#ifdef HAVE_OPENCV_FLANN
#include "opencv2/flann.hpp"
#endif
#ifdef HAVE_OPENCV_HIGHGUI
#include "opencv2/highgui.hpp"
#endif
#ifdef HAVE_OPENCV_IMGPROC
#include "opencv2/imgproc.hpp"
#endif

#endif
