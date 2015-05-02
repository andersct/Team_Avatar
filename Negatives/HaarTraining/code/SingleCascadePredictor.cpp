/*
 * SingleCascadePredictor.cpp
 *
 *  Created on: May 1, 2015
 *      Author: CyrusAnderson
 */

#include "SingleCascadePredictor.h"
//#include "PruneRule.h"
#include <stdio.h>
#include <functional>
//#include <iostream>


//enum PruneRule { HIGH_BOUND, LOW_BOUND };
Scalar PRUNE_RULE_COLORS[2] = { {250, 10, 14}, {10, 226, 250}}; //todo fix build order to put this in the const


SingleCascadePredictor::SingleCascadePredictor(Size _input_size, double _cutoff_percentage,
		vector<PruneProcessor *> &_rules) : input_size(_input_size), cutoff_percentage(_cutoff_percentage) {
	for (auto &r : _rules) {
		rules.push_back(r->clone());
	}
}

void SingleCascadePredictor::init(string cascade_path) {
	if(!cascade.load(cascade_path)) {
		std::cout << "--(!)Error loading sphere: " << cascade_path << endl;
		assert(false);
	};
	cutoff_rows = cvRound(cutoff_percentage*input_size.height);
	roi = Rect(0, cutoff_rows,
			input_size.width, input_size.height-cutoff_rows);
}

vector<Rect> SingleCascadePredictor::predict(Mat &frame, int min_neighbors, Size min) {
	Mat roi = frame(Rect(0, cutoff_rows, frame.cols, frame.rows-cutoff_rows));
	Mat frame_gray;
	cvtColor( roi, frame_gray, CV_BGR2GRAY );
	equalizeHist( frame_gray, frame_gray );
	cascade.detectMultiScale( frame_gray, predictions, 1.1, min_neighbors, 0|CV_HAAR_SCALE_IMAGE, min);

	//adjust to account for cutoff
	for (auto &r : predictions) {
		r.y += cutoff_rows;
	}
	return predictions;
}

vector<pair<Rect,PruneRule>> SingleCascadePredictor::prune() {
	vector<Rect>::iterator iter;
	for (iter = predictions.begin(); iter != predictions.end(); ) {
		bool passed = true;
		for (int i=0; i<rules.size(); ++i) {
			Rect r(*iter);
			r.y -= cutoff_rows;
			if (!(rules[i]->passesRule(r))) {
				r.y += cutoff_rows;
				pruned.push_back(pair<Rect,PruneRule>(r, rules[i]->getRule()));
				passed = false;
				break;
			}
		}
		if (passed) {
			++iter;
		} else {
			iter = predictions.erase(iter);
		}
	}
	return pruned;
}

void SingleCascadePredictor::clearPredictions() {
	predictions.clear();
	pruned.clear();
}

void SingleCascadePredictor::drawRoi(Mat &frame, Scalar color) {
	rectangle(frame, Rect(0, cutoff_rows, frame.cols, frame.rows-cutoff_rows), color);
}

void SingleCascadePredictor::drawPruned(Mat &frame) {
	for (pair<Rect,PruneRule> p : pruned) {
		rectangle(frame, p.first, PRUNE_RULE_COLORS[p.second]);
//		if (p.second == (PruneRule) HIGH_BOUND) {
//			rectangle(frame, p.first, PRUNE_RULE_COLORS[p.second]); ///add color getting fcns to prunerule.h
//		} else if (p.second == (PruneRule) LOW_BOUND) {
//			rectangle(frame, p.first, PRUNE_RULE_COLORS[p.second]);
//		}
	}
}

void SingleCascadePredictor::drawPredictions(Mat &frame) {
	for (size_t i = 0; i < predictions.size() && i < num_drawn; i++ ) {
		Rect r(predictions[i]);
		//r.y += cutoff_rows;
//		ss << " " << bb[i].x << " " << bb[i].y << " " <<
//		bb[i].width << " " << bb[i].height;
		//color is pinkish - BGR format
		rectangle(frame, r, Scalar(171, 122, 234));
	}
}

//ostringstream& SingleCascadePredictor::writePredictions(vector<Rect> &bb, ostringstream &os) {
//	for (size_t i = 0; i < bb.size() && i < num_drawn; i++ ) {
//		bb[i].y += cutoff_rows;
//		os << " " << bb[i].x << " " << bb[i].y << " " <<
//				bb[i].width << " " << bb[i].height;
//	}
//	return os;
//}

SingleCascadePredictor::~SingleCascadePredictor() {
//	for (auto r : rules) {
//		delete r;
//	} //bad stuff ~ local copy's ptrs got deleted
}


//ostream& operator<<(ostream& os, vector<Rect> &bb) {
//	for (size_t i = 0; i < bb.size() && i < num_drawn; i++ ) {
//		bb[i].y += cutoff_rows;
//		os << " " << bb[i].x << " " << bb[i].y << " " <<
//				bb[i].width << " " << bb[i].height;
//	}
//	return os;
//}

