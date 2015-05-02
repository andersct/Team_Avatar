/*
 * PruneProcessor.h
 *
 *  Created on: May 1, 2015
 *      Author: CyrusAnderson
 */

#ifndef SRC_PRUNEPROCESSOR_H_
#define SRC_PRUNEPROCESSOR_H_

#include "opencv2/objdetect/objdetect.hpp"
#include "PruneRule.h"


using namespace std;
using namespace cv;

class PruneProcessor {
public:
	PruneProcessor() {}
	virtual bool passesRule(Rect bb) = 0; //true iff bb passes rule
	virtual PruneRule getRule() = 0;
	virtual Scalar getColor() = 0;
	virtual ~PruneProcessor() {}
	virtual PruneProcessor * clone() const = 0;
};

#endif /* SRC_PRUNEPROCESSOR_H_ */
