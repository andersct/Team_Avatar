## Color Detection Under Supervised Learning

Red. Green. Blue. Yellow. Black. White. Long ago, the seven colors lived together in harmony. Then everything changed when the Black Buoys attacked. Only the SVM Classifier, master of all seven colors, could stop them, but when the world needed him most, he vanished. A couple weeks passed and our group discovered the new SVM Classifier, an algorithm named TACA (Team Avatar Classifier Algorithm). And although his classification skills are great, it has a lot to learn before it's ready to classify anything. But I believe TACA can classify the world.

![alt tag](https://github.com/andersct/Team_Avatar/blob/master/fire_nation.jpg)

## Introduction

We present multiple supervised learning approaches to a common problem: color classification. From the simple k-nearest neighbors to machine learning SVM, there are a variety of approaches to this problem. Some solutions may perform better than others depending on the specific application and constraints. Here, our objective is to classify the colors of buoys on the surface of a pond during an autonomous robotic boat challenge under variations (e.g. time of day, weather, and lighting conditions). Our aim is to allow the autonomous robotic boat to use our classifier to make color classifications during the challenge. This report will compare results from basic non-learning algorithms such as majority-voting and average color, with more sophisticated learning algorithms such as Naive Bayes and multiclass SVM. 

## Instructions

1. ????
2. Profit

## How Data was Created

1. Retreived buoy images from autonomous boat log files:
2. Used 'labelBoxes.m' to hand-label buoys
3. Used 'makeData.m' for standarizing and extracting features from the hand-labeled data
4. Used Blender to render artifical data
5. Then used 'makeSyntheticData.m' to standarize and extract features from the synthetic data

## Algorithms Implemented
* Basic Algorithms:

	* Majority Vote (/majorityvote.m)
		* Accuracy:

	* Average vote  (/averagevote.m)
		* Accuracy:

* Advanced Algorithms:

	* Naives Bayes (nb_script.m)
		* Accuracy:

	* LIBLINEAR SVM with/without kernels (liblinear-1.94)
		* Data trained/ tested on
		* Accuracy:

	* LIBSVM (libsvm-3.20) (for weighting synthetic data)
		* Data trained/ tested on
		* Accuracy:

	* Softmax Regression (softmax_regression.m)
		* Accuracy:

## Testing
