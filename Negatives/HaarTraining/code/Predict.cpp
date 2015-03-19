#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>

using namespace std;
using namespace cv;

/** Function Headers */
void writePrediction(Mat frame, String link);

/** Global variables */
String cascade_name = "Negatives/HaarTraining/code/cascade.xml";
String repo_dir = "/Users/cyrusanderson/Team_Avatar/";
String label_info = "labeled_.vec";
CascadeClassifier cascade;
string window_name = "Capture - buoy detection";
int numDrawn = 10;
RNG rng(12345);

/** @function main */
int main( int argc, const char** argv )
{
    
    CvCapture* capture;
    Mat frame;
    
    //-- 1. Load the cascades
    if( !cascade.load(repo_dir + cascade_name) ){ printf("--(!)Error loading\n"); return -1; };
    
    ifstream link_file(repo_dir + label_info);
    cout << repo_dir + label_info << endl;
    String line;
    while (getline(link_file, line) && line != "") {
        istringstream iss(line);
        String link;
        if (!(iss >> link)) {
            break;
            //error
        }
        //cout << link << endl; //deb
        
        frame = imread(repo_dir + link, 1 );
        writePrediction(frame, link);
        int c = waitKey(10);
    }
    
    return 0;
}

void writePrediction(Mat frame, String link) {
    vector<Rect> bb;
    Mat frame_gray;
    
    cvtColor( frame, frame_gray, CV_BGR2GRAY );
    equalizeHist( frame_gray, frame_gray );
    cascade.detectMultiScale( frame_gray, bb, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, Size(30, 30) );
    
    ostringstream ss;
    for( size_t i = 0; i < bb.size() && i < numDrawn; i++ )
    {
        ss << " " << bb[i].x << " " << bb[i].y << " " << bb[i].width << " " << bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, bb[i], Scalar(171, 122, 234));
        imshow(window_name, frame);
    }
    // if exist predictions
    if (ss.str() != "") {
        cout << ss.str() << endl;
    }
}
