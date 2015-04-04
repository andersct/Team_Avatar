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
String cascade_dir = "Negatives/HaarTraining/";
String repo_dir = "/Users/cyrusanderson/Team_Avatar/";
String test_items = "Negatives/sphere-train.txt"; //HaarTraining/code/test.txt";
CascadeClassifier cascade;
String window_name = "Capture - buoy detection";
int numDrawn = 10;
RNG rng(12345);

/** @function main */
int main( int argc, const char** argv )
{
    
    CvCapture* capture;
    Mat frame;
    // sphere|nun
    cascade_dir += string(argv[1]) + "-model/cascade.xml";
    test_items = string(argv[2]); //relative path from repo to test
    
    //-- 1. Load the cascades
    if( !cascade.load(repo_dir + cascade_dir) ){ printf("--(!)Error loading %s\n", (repo_dir + cascade_dir).c_str()); return -1; }; //original
    
    ifstream link_file(repo_dir + test_items);
    //cout << repo_dir + test_items << endl; //deb
    String line;
    while (getline(link_file, line) && line != "") {
        istringstream iss(line);
        String link;
        if (!(iss >> link)) {
            break;
            //error
        }
        
        
        frame = imread(repo_dir + link, 1 );
        writePrediction(frame, link);
        int c = waitKey(10);
    }
    
    return 0;
}

void writePrediction(Mat frame, String link) {
    vector<Rect> bb;
    
    bool cutoff = true;
    bool grayscale = true;
    double cutoff_percentage = .3;
    Mat roi = frame;
    int cutoff_rows = 0;
    if (cutoff) {
        cutoff_rows = cvRound(cutoff_percentage*frame.rows);
        rectangle(frame, Rect(0, cutoff_rows, frame.cols, frame.rows-cutoff_rows), Scalar(171, 122, 10));
        roi = frame(Rect(0, cutoff_rows, frame.cols, frame.rows-cutoff_rows));
    }
    
    Mat frame_gray;
    frame_gray = roi;
    if (grayscale) {
        cvtColor( roi, frame_gray, CV_BGR2GRAY );
        equalizeHist( frame_gray, frame_gray );
    }
    cascade.detectMultiScale( frame_gray, bb, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, Size(30, 30) );
    
    ostringstream ss;
    for ( size_t i = 0; i < bb.size() && i < numDrawn; i++ ) {
        bb[i].y += cutoff_rows;
        ss << " " << bb[i].x << " " << bb[i].y << " " << bb[i].width << " " << bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, bb[i], Scalar(171, 122, 234));
        imshow(window_name, frame);
        //waitKey(10); //deb
    }
    // if no predictions, indicate so
    cout << link; //path to img
    cout << ss.str() << endl;
}
