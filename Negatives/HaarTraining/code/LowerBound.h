/*
 * LowerBound.h
 *
 *  Created on: May 1, 2015
 *      Author: CyrusAnderson
 */

#ifndef SRC_LOWERBOUND_H_
#define SRC_LOWERBOUND_H_

#include "PruneProcessor.h"

class LowerBound: public PruneProcessor {
	double fudgeFactor;
	double factorDecay;
	double thresholds[9];	//lookup bins as described in paper - 30px intervals
	double im_height;		//height of ROI on which predictions were made
public:
	LowerBound(double _fudgeFactor, double _factorDecay, double _thresholds[], double _im_height);
	virtual bool passesRule(Rect bb);
	virtual PruneRule getRule() { return LOW_BOUND; }
	virtual Scalar getColor() { return Scalar(10, 226, 250); }
	virtual ~LowerBound();
	LowerBound(const LowerBound& _rhs);
	virtual LowerBound * clone() const { return new LowerBound(*this); }
};

#endif /* SRC_LOWERBOUND_H_ */
