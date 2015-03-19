# works for test and train data
def evaluate_predictions(labels, preds, min_dist):
    """
    :param labels: ground truth in [left x, top y, w, h, ...
    :param preds: predictions in [left x, top y, w, h, ...
    :return: tp: number of true negatives, fp: false positives, fn: false negatives (tn makes no sense?), num_real
    """
    num_preds = len(preds)/4
    num_real = len(labels)/4

    matches = [-1] * num_real
    fp = 0
    for i in range(0, num_preds):
        # for all of preds, find overlap with each real and vote for the best real box
        # others (less overlap) voting for same box are duplicate detection --> false positive
        # preds with < MIN_OVERLAP on all are counted as false positives
        # boxes with no preds are false negatives

        # num < T on all --> fp
        # this one replaces a prev-made match --> fp
        # makes a new match --> do nothing
        # can only 'vote' for best match
        scores = [-1] * num_real
        for j in range(0, num_real):
            print('i, j: ' + str(i) + ' ' + str(j))
            scores[j] = box_dist(map(int, preds[4*i: 4+4*i]), map(int, labels[4*j: 4+4*j]))
        best = max(scores)
        other = matches[scores.index(best)]
        if best < min_dist or best < other:
            fp += 1
        elif other != -1:
            fp += 1
            matches[scores.index(best)] = best
        else:
            matches[scores.index(best)] = best
    fn = sum(x < 0 for x in matches)
    tp = sum(x > 0 for x in matches)

    return tp, fp, fn, num_real


def box_dist(b1, b2):
    """
    :param b1: [left x, top y, w, h]
    :param b2: [left x, top y, w, h]
    :return: % overlap as area(intersection) / area(union)
    """
    b1max_x = b1[0] + b1[2]
    b1max_y = b1[1] + b1[3]
    b2max_x = b2[0] + b2[2]
    b2max_y = b2[1] + b2[3]

    # intersection
    # the +1 is due to inclusive bounding box
    bi = [max(b1[0], b2[0]), max(b1[1], b2[1]), min(b1max_x, b2max_x), min(b1max_y, b2max_y)]
    iw = bi[2] - bi[0] + 1
    ih = bi[3] - bi[1] + 1
    if iw <= 0 or ih <= 0:
        return 0

    # union
    ua = (b1max_x - b1[0] + 1)*(b1max_y - b1[1] + 1) + (b2max_x - b2[0] + 1)*(b2max_y - b2[1] + 1) - iw*ih
    return iw*ih/float(ua)


