import box_test_helper
from itertools import izip

training = 'training.txt'
predictions = 'predictions.txt'
MIN_OVERLAP = 0.5

tp = 0
fp = 0
fn = 0
total = 0
with open(training, 'r') as training_file, open(predictions, 'r') as pred_file:
    for truth, pred in izip(training_file, pred_file):

        labels = truth.strip('\n\r').split(' ')
        preds = pred.strip('\n\r').split(' ')
        print(labels)
        print(preds)
        # make sure first arg matches? [link, [box1], [box2], ...

        img_tp, img_fp, img_fn, boxes = box_test_helper.evaluate_predictions(labels[1:], preds[1:], MIN_OVERLAP)
        print(img_tp, img_fp, img_fn, boxes)
        tp += img_tp
        fp += img_fp
        fn += img_fn
        total += boxes


