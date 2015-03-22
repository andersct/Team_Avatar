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
String cascade_name = "Negatives/HaarTraining/model/cascade.xml";
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
