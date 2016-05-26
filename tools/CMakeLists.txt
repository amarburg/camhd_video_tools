cmake_minimum_required(VERSION 2.8.7)
project(camhd_video_tools)
#include(ExternalProject)

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR})
set(RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

list(APPEND OPENCV_COMPONENTS core highgui imgproc video)

option(USE_GPU "Build GPU-accelerated tools" OFF)
if( USE_GPU )
	add_definitions( -DUSE_GPU )
	list(APPEND OPENCV_COMPONENTS gpu )
endif()

find_package(OpenCV 2.4 COMPONENTS ${OPENCV_COMPONENTS} REQUIRED)

## C++ flags applied to all builds
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

## Set global include paths
include_directories( ${OpenCV_INCLUDE_DIRS} )

# build image node
add_executable(every_frame EveryFrame.cpp )
target_link_libraries( every_frame
						${OpenCV_LIBRARIES})
