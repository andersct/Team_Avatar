import box_test_helper
from itertools import izip

training = 'info.txt'
predictions = 'predictions.txt' # 'predictionsGrayCutoff.txt'  #  'predictionsColor.txt'  # 'predictions.txt'
repo = '/Users/CyrusAnderson/Documents/Team_Avatar/'
MIN_OVERLAP = 0.4  # 0.5 was a bit too high. 0.4 is slightly lenient
show_results = True

tp = 0
fp = 0
fn = 0
total = 0
with open(training, 'r') as training_file, open(predictions, 'r') as pred_file:
    for truth, pred in izip(training_file, pred_file):

        labels = truth.strip('\n\r').split(' ')
        preds = pred.strip('\n\r').split(' ')
        # make sure first arg matches? [link, number of boxes, [box1], [box2], ...
        print(labels)
        # [link, [box1], [box2], ...
        print(preds)

        img_tp, img_fp, img_fn, boxes, matches = \
            box_test_helper.evaluate_predictions(labels[2:], preds[1:], MIN_OVERLAP)
        print(img_tp, img_fp, img_fn, boxes)
        tp += img_tp
        fp += img_fp
        fn += img_fn
        total += boxes

        if show_results:
            box_test_helper.plot_matches(repo+labels[0], map(int, matches),
                                         map(int, labels[2:]), map(int, preds[1:]), True)

print(total, tp, fp, fn)
