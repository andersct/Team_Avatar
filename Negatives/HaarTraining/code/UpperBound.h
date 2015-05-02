/*
 * UpperBound.h
 *
 *  Created on: May 1, 2015
 *      Author: CyrusAnderson
 */

#ifndef SRC_UPPERBOUND_H_
#define SRC_UPPERBOUND_H_

#include "PruneProcessor.h"

class UpperBound: public PruneProcessor {
	double fudgeFactor;
	double factorDecay;
	double thresholds[9];	//lookup bins as described in paper - 30px intervals
	double im_height;		//height of ROI on which predictions were made
public:
	UpperBound(double _fudgeFactor, double _factorDecay, double _thresholds[], double _im_height);
	virtual bool passesRule(Rect bb);
	virtual PruneRule getRule() { return HIGH_BOUND; }
	virtual Scalar getColor() { return Scalar(250, 10, 14); }
	virtual ~UpperBound();
	UpperBound(const UpperBound& _rhs);
	virtual UpperBound * clone() const { return new UpperBound(*this); }
};

#endif /* SRC_UPPERBOUND_H_ */
