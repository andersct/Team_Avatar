#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>

using namespace std;
using namespace cv;

//labeled_.vec for all
//j1 for test sphere/nun
// code/test.txt for test-all


enum PruneRule { HIGH_BOUND, LOW_BOUND };
Scalar rule_one_color(250, 10, 14);
Scalar rule_two_color(10, 226, 250);


/** Function Headers */
void writePrediction(Mat frame, String link);
int makePrediction(Mat frame, vector<Rect> &bb, CascadeClassifier &cascade,
                    double cutoff_percentage, bool grayscale);

vector<pair<Rect,PruneRule>> pruneDistanceSphere(vector<Rect> &bb);
vector<pair<Rect,PruneRule>> pruneDistanceNun(vector<Rect> &bb);
double maxHeightSphere(Rect bb);
double maxHeightNun(Rect bb);

double minHeightSphere(Rect bb);
double minHeightNun(Rect bb);


/** Global variables */
String sphere_cascade_path = "Negatives/HaarTraining/sphere-model/cascade.xml";
String nun_cascade_path = "Negatives/HaarTraining/nun-model/cascade.xml";
String repo_dir = "/Users/CyrusAnderson/Documents/Team_Avatar/"; // << set this for portability
String test_items = "Negatives/sphere-train.txt"; //HaarTraining/code/test.txt";
CascadeClassifier sphere_cascade;
CascadeClassifier nun_cascade;
String window_name = "Capture - buoy detection";
int numDrawn = 10;
RNG rng(12345);

/** @function main */
int main( int argc, const char** argv )
{

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
        int c = waitKey(20);
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
    vector<pair<Rect,PruneRule>> spherePruned = pruneDistanceSphere(sphere_bb);
    int nun_row_offset = makePrediction(frame, nun_bb, nun_cascade, nun_cutoff, grayscale);
    vector<pair<Rect,PruneRule>> nunPruned = pruneDistanceNun(nun_bb);

    ostringstream ss;
    //sphere
    for( size_t i = 0; i < sphere_bb.size() && i < numDrawn; i++ )
    {
        sphere_bb[i].y += sphere_row_offset;
        ss << " " << sphere_bb[i].x << " " << sphere_bb[i].y << " " <<
        sphere_bb[i].width << " " << sphere_bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, sphere_bb[i], Scalar(171, 122, 234));
    }
    //nun
    for( size_t i = 0; i < nun_bb.size() && i < numDrawn; i++ )
    {
        nun_bb[i].y += nun_row_offset;
        ss << " " << nun_bb[i].x << " " << nun_bb[i].y << " " <<
        nun_bb[i].width << " " << nun_bb[i].height;
        //color is pinkish - BGR format
        rectangle(frame, nun_bb[i], Scalar(171, 122, 234));
    }

    for (pair<Rect,PruneRule> p : spherePruned) {
    	p.first.y += sphere_row_offset;
    	if (p.second == (PruneRule) HIGH_BOUND) {
    		rectangle(frame, p.first, rule_one_color);
    	} else if (p.second == (PruneRule) LOW_BOUND) {
    		rectangle(frame, p.first, rule_two_color);
    	}
    }

    for (pair<Rect,PruneRule> p : nunPruned) {
    	p.first.y += nun_row_offset;
    	if (p.second == (PruneRule) HIGH_BOUND) {
			rectangle(frame, p.first, rule_one_color);
		} else if (p.second == (PruneRule) LOW_BOUND) {
			rectangle(frame, p.first, rule_two_color);
		}
	}

    imshow(window_name, frame);

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
    cascade.detectMultiScale( frame_gray, bb, 1.1, 5, 0|CV_HAAR_SCALE_IMAGE, Size(30, 30) );
    return cutoff_rows;
}

vector<pair<Rect,PruneRule>> pruneDistanceSphere(vector<Rect> &bb) {
	vector<pair<Rect,PruneRule>> pruned;
	vector<Rect>::iterator iter;
	for (iter = bb.begin(); iter != bb.end(); ) {
		if (iter->height > maxHeightSphere(*iter)) {
			pruned.push_back(make_pair(*iter, (PruneRule) HIGH_BOUND));
			iter = bb.erase(iter);
		} else if (iter->height < minHeightSphere(*iter)) {
			pruned.push_back(make_pair(*iter, (PruneRule) LOW_BOUND));
			iter = bb.erase(iter);
		} else {
			++iter;
		}
	}
	return pruned;
}

vector<pair<Rect,PruneRule>> pruneDistanceNun(vector<Rect> &bb) {
	vector<pair<Rect,PruneRule>> pruned;
	vector<Rect>::iterator iter;
	for (iter = bb.begin(); iter != bb.end(); ) {
	    if (iter->height > maxHeightNun(*iter)) {
	    	pruned.push_back(make_pair(*iter, (PruneRule) HIGH_BOUND));
	    	iter = bb.erase(iter);
	    } else if (iter->height < minHeightNun(*iter)) {
	    	pruned.push_back(make_pair(*iter, (PruneRule) LOW_BOUND));
	    	iter = bb.erase(iter);
	    } else {
	    	++iter;
	    }
	}
	return pruned;
}

//increments of 30px
double maxHeightSphere(Rect bb) {
	double largeBuoyFudgeFactor = 40;
	double factorDecay = 4;
	double thresholds[9] = {
			133.4353,  133.0000,  133.0000,
			89.0000,   80.0000,   66.2400,
			58.0000,   42.9333,   21.0000};
	double im_height = 482 - 482*.45;
	double pixel_distance_im_to_bb = im_height - bb.y - bb.height;
	for (int i=0; i<8; ++i) {
		if (pixel_distance_im_to_bb < (i+1)*30) {
			return thresholds[i] + largeBuoyFudgeFactor - factorDecay*i;
		}
	}
	return thresholds[8] + largeBuoyFudgeFactor - factorDecay*8;
}

//increments of 30px
double maxHeightNun(Rect bb) {
	double fudgeFactor = 40;
	double factorDecay = 2;
	double thresholds[9] = {
			372.9067,  333.6533,  276.3267,
			219.0000,  240.9037,  181.5467,
			155.7867,   94.0000,   86.0000};
	double im_height = 482 - 482*.3;
	double pixel_distance_im_to_bb = im_height - bb.y - bb.height;
	for (int i=0; i<8; ++i) {
		if (pixel_distance_im_to_bb < (i+1)*30) {
			return thresholds[i] + fudgeFactor - factorDecay*i;
		}
	}
	return thresholds[8] + fudgeFactor - factorDecay*8;
}


// LOWER BOUNDS
double minHeightSphere(Rect bb) {

	double thresholds[9] = {
			72.3733,   66.2400,   53.0000,
			35.5733,   28.0000,   23.0000,
			12.0000,   10.0000,    8.0000};
	double im_height = 482 - 482*.45;
	double pixel_distance_im_to_bb = im_height - bb.y - bb.height;
	for (int i=0; i<8; ++i) {
		if (pixel_distance_im_to_bb < (i+1)*30) {
			return thresholds[i];
		}
	}
	return thresholds[8];
}

double minHeightNun(Rect bb) {
	double fudgeFactor = 120;
	double factorDecay = 1.5;
	double thresholds[9] = {
			356.9600,  333.6533,  320,
			209.7914,  158.0000,  102.5630,
			47.0000,   30.0000,   39.0000};
	double im_height = 482 - 482*.3;
	double pixel_distance_im_to_bb = im_height - bb.y - bb.height;
	for (int i=0; i<8; ++i) {
		if (pixel_distance_im_to_bb < (i+1)*30) {
			return thresholds[i] - fudgeFactor;
		}
		fudgeFactor /= factorDecay;
	}
	return thresholds[8];
}
