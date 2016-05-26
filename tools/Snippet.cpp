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

	float fps = capture.get( CV_CAP_PROP_FPS );
	if( fps > 0 ) {
		cout << "Video at " << fps << " fps" << endl;
} else {
		cout << "Can't get fps for video, using 29.97" << endl;
		fps = 29.97;
}

	const int numFrames = int(29.97 * 30);
	const int seekTo = int(fps * (5*60 + 30));

	int frames = 0;
	Mat img;

	// seek first
	cout << "Seeking to frame " << seekTo << endl;
	capture.set( CV_CAP_PROP_POS_FRAMES, seekTo );

	while( capture.read( img ) && frames < numFrames ) {
		++frames;

		if( frames % 100 == 0 )
			cout << "Frame " << frames << endl;
	}
}
