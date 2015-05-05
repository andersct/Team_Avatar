/*
 * SingleCascadePredictor.h
 *
 *  Created on: May 1, 2015
 *      Author: CyrusAnderson
 */

#ifndef SRC_SINGLECASCADEPREDICTOR_H_
#define SRC_SINGLECASCADEPREDICTOR_H_

#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
//#include <ostream>


#include "PruneProcessor.h"


using namespace std;
using namespace cv;


class SingleCascadePredictor {
	Size input_size;
	double cutoff_percentage;
	vector<PruneProcessor *> rules;
	CascadeClassifier cascade;
	Rect roi;
	int cutoff_rows = 0;
	int num_drawn = 10;
	vector<Rect> predictions;
	vector<pair<Rect,PruneRule>> pruned;

public:
	SingleCascadePredictor() = default;
	SingleCascadePredictor(Size _input_size, double _cutoff_percentage, vector<PruneProcessor *> &_rules);
	void init(string cascade_path);
	vector<Rect> predict(Mat &frame, int min_neighbors, Size min);
	vector<pair<Rect,PruneRule>> prune();
	void clearPredictions();
	vector<Rect> getPredictions() const { return predictions; }

	// assumes frame size = input_size
	void drawRoi(Mat &frame, Scalar color = Scalar(171, 122, 10));
	void drawPruned(Mat &frame);

	void drawPredictions(Mat &frame);
	//ostringstream& writePredictions(vector<Rect> &bb, ostringstream &os);
	virtual ~SingleCascadePredictor();

	friend ostream& operator<<(ostream& os, const SingleCascadePredictor &scp);
};

//inline or linker errors will occur
//http://www.cplusplus.com/forum/general/85317/
 inline std::ostream& operator<<(std::ostream& os, const SingleCascadePredictor &scp) {
	for (size_t i = 0; i < scp.predictions.size() && i < scp.num_drawn; i++ ) {
		os << " " << scp.predictions[i].x << " " << scp.predictions[i].y << " " <<
				scp.predictions[i].width << " " << scp.predictions[i].height;
	}
	return os;
}

#endif /* SRC_SINGLECASCADEPREDICTOR_H_ */
