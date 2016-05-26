#include <iostream>
#include <string>

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

int main( int argc, char **argv )
{
	string filename( argv[argc-1] );

	cout << "Opening file " << filename << endl;

	VideoCapture capture( filename );

	if( !capture.isOpened() ) {
		cerr << "Couldn't open " << filename << endl;
		exit(-1);
	}


	int frames = 0;
	Mat img;
	while( capture.read( img ) ) {
		++frames;

		if( frames % 100 == 0 )
			cout << "Frame " << frames << endl;
	}
}
