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
int makePrediction(Mat frame, vector<Rect> &bb, CascadeClassifier &cascade,
                    double cutoff_percentage, bool grayscale);

/** Global variables */
String sphere_cascade_path = "Negatives/HaarTraining/sphere-model/cascade.xml";
String nun_cascade_path = "Negatives/HaarTraining/nun-model/cascade.xml";
String repo_dir = "/Users/cyrusanderson/Team_Avatar/";
String test_items = "Negatives/sphere-train.txt"; //HaarTraining/code/test.txt";
CascadeClassifier sphere_cascade;
CascadeClassifier nun_cascade;
String window_name = "Capture - buoy detection";
int numDrawn = 10;
RNG rng(12345);

/** @function main */
int main( int argc, const char** argv )
{
    
    CvCapture* capture;
    Mat frame;
    test_items = string(argv[1]); //relative path from repo to test
    
    //-- 1. Load the cascades
    String temp = repo_dir + sphere_cascade_path;
    if(!sphere_cascade.load(repo_dir + sphere_cascade_path)) {
        string warning = "--(!)Error loading sphere: " +repo_dir + sphere_cascade_path+ "\n";
        printf("%s \n", warning.c_str());
        return -1;
    };
    if(!nun_cascade.load(repo_dir + nun_cascade_path)) {
        string warning = "--(!)Error loading nun: " +repo_dir + nun_cascade_path;
        printf("%s \n", warning.c_str());
        return -1;
    };
    
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
    vector<Rect> sphere_bb;
    vector<Rect> nun_bb;
    
    double sphere_cutoff = .45;
    double nun_cutoff = .30;
    bool grayscale = true;
    
    int sphere_row_offset = makePrediction(frame, sphere_bb, sphere_cascade, sphere_cutoff, grayscale);
    int nun_row_offset = makePrediction(frame, nun_bb, nun_cascade, nun_cutoff, grayscale);
    
    ostringstream ss;
    //sphere
    for( size_t i = 0; i < sphere_bb.size() && i < numDrawn; i++ )
    {
        sphere_bb[i].y += sphere_row_offset;
        ss << " " << sphere_bb[i].x << " " << sphere_bb[i].y << " " <<
        sphere_bb[i].width << " " << sphere_bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, sphere_bb[i], Scalar(171, 122, 234));
        imshow(window_name, frame);
    }
    //nun
    for( size_t i = 0; i < nun_bb.size() && i < numDrawn; i++ )
    {
        nun_bb[i].y += nun_row_offset;
        ss << " " << nun_bb[i].x << " " << nun_bb[i].y << " " <<
        nun_bb[i].width << " " << nun_bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, nun_bb[i], Scalar(171, 122, 234));
        imshow(window_name, frame);
    }
    // if no predictions, indicate so
    cout << link; //path to img
    cout << ss.str() << endl;
}

int makePrediction(Mat frame, vector<Rect> &bb, CascadeClassifier &cascade,
                    double cutoff_percentage, bool grayscale) {
    bool cutoff = cutoff_percentage > 0;
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
    return cutoff_rows;
}
