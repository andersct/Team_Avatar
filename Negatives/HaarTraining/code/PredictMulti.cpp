/*
 * DisplayImage.cpp
 *
 *  Created on: Jan 6, 2015
 *      Author: CyrusAnderson
 */

#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

#include <fstream>
#include <stdio.h>

#include "UpperBound.h"
#include "LowerBound.h"
#include "SingleCascadePredictor.h"



using namespace std;
using namespace cv;

//labeled_.vec for all
//j1 for test sphere/nun
// code/test.txt for test-all


/** Function Headers */
double getImageCutoffHeight(int imHeight, double cutoff_percentage) {
	return imHeight*(1-cutoff_percentage);
}

void initCascades();

/** Global variables */
String sphere_cascade_path = "Negatives/HaarTraining/sphere-model/cascade.xml";
String nun_cascade_path = "Negatives/HaarTraining/nun-model/cascade.xml";
String repo_dir = "/Users/CyrusAnderson/Documents/Team_Avatar/"; // << set this for portability
String test_items = "Negatives/sphere-train.txt"; //HaarTraining/code/test.txt";
CascadeClassifier sphere_cascade;
CascadeClassifier nun_cascade;
String window_name = "Capture - buoy detection";
int numDrawn = 10;

int imHeight = 482;
SingleCascadePredictor sphereCascade;
SingleCascadePredictor nunCascade;


/** @function main */
int main( int argc, const char** argv )
{
    Mat frame;
    test_items = string(argv[1]); //relative path from repo to test

    /*
     * Initialize cutoffs and prune rules
     */
    initCascades();

    ifstream link_file(repo_dir + test_items);
    //cout << repo_dir + test_items << endl; //deb
    ostringstream os;

    String line;
    while (getline(link_file, line) && line != "") {
        istringstream iss(line);
        String link;
        if (!(iss >> link)) {
            break;
            //error
        }


        frame = imread(repo_dir + link, 1 );

        vector<Rect> preds = sphereCascade.predict(frame, 4, Size(35,35));
        vector<pair<Rect,PruneRule>> pruned = sphereCascade.prune();
        sphereCascade.drawPredictions(frame);
        sphereCascade.drawPruned(frame);
        sphereCascade.drawRoi(frame);

        vector<Rect> preds1 = nunCascade.predict(frame, 4, Size(20,20));
		vector<pair<Rect,PruneRule>> pruned1 = nunCascade.prune();
		nunCascade.drawPredictions(frame);
		nunCascade.drawPruned(frame);
		nunCascade.drawRoi(frame);

		os << link << sphereCascade << nunCascade;
		cout << os.str() << endl;
		os.str("");
		imshow(window_name, frame);

		sphereCascade.clearPredictions();
		nunCascade.clearPredictions();
        waitKey(20);
    }

    return 0;
}

void initCascades() {
	double thresholdsSU[9] = {
			133.4353,  133.0000,  133.0000,
			89.0000,   80.0000,   66.2400,
			58.0000,   42.9333,   21.0000};
	vector<PruneProcessor *> sphereRules;
	sphereRules.push_back(new UpperBound(40, 4, thresholdsSU, getImageCutoffHeight(imHeight, .45)));
	double thresholdsSL[9] = {
			72.3733,   66.2400,   53.0000,
			35.5733,   28.0000,   23.0000,
			12.0000,   10.0000,    8.0000};
	//1, 0 for no leniency term
	sphereRules.push_back(new LowerBound(1, 0, thresholdsSL, getImageCutoffHeight(imHeight, .45)));
	sphereCascade = SingleCascadePredictor(Size(644, 482), .45, sphereRules);
	sphereCascade.init(repo_dir + sphere_cascade_path);



	vector<PruneProcessor *> nunRules;
	double thresholdsNU[9] = {
			372.9067,  333.6533,  276.3267,
			219.0000,  240.9037,  181.5467,
			155.7867,   94.0000,   86.0000};
	nunRules.push_back(new UpperBound(40, 2, thresholdsNU, getImageCutoffHeight(imHeight, .30)));
	double thresholdsNL[9] = {
			356.9600,  333.6533,  320,
			209.7914,  158.0000,  102.5630,
			47.0000,   30.0000,   39.0000};
	nunRules.push_back(new LowerBound(120, 1.5, thresholdsNL, getImageCutoffHeight(imHeight, .30)));
	nunCascade = SingleCascadePredictor(Size(644, 482), .30, nunRules);
	nunCascade.init(repo_dir + nun_cascade_path);
}

