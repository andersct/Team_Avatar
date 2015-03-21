import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from matplotlib.patches import Rectangle


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
    mapping = [-1] * num_real
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
            scores[j] = box_dist(map(int, get_box(preds, i)), map(int, get_box(labels, j)))
        best = max(scores)
        other = matches[scores.index(best)]
        if best < min_dist or best < other:
            fp += 1
        elif other != -1:
            fp += 1
            matches[scores.index(best)] = best
            mapping[scores.index(best)] = i
        else:
            matches[scores.index(best)] = best
            mapping[scores.index(best)] = i
    fn = sum(x < 0 for x in matches)
    tp = sum(x > -1 for x in matches)

    print('stats')
    print(mapping)
    print(matches)
    return tp, fp, fn, num_real, mapping


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


def plot_matches(link, match, labels, preds, show_all_preds):
    """
    Plots labels and predictions and opens the image in a window, pausing until closed.
    :param link:    filepath to image
    :param match:   list of preds matching labels: match[i] = j if pred j matches label i
                    -1 if no match, as ints
    :param labels: ground truth in [left x, top y, w, h, ... as ints
    :param preds: predictions in [left x, top y, w, h, ... as ints
    :param show_all_preds: shows all predictions iff true
    :return:
    """
    im = mpimg.imread(link)
    plt.imshow(im)
    if show_all_preds:
        plot_all_predictions(match, labels, preds)
    else:
        plot_matching_predictions(match, labels, preds)
    plt.show()


def plot_matching_predictions(match, labels, preds):
    """
    Plots all matching predictions.
    :param match:   list of preds matching labels: match[i] = j if pred j matches label i
                    -1 if no match, as ints
    :param labels: ground truth in [left x, top y, w, h, ... as ints
    :param preds: predictions in [left x, top y, w, h, ... as ints
    """
    for i, m in enumerate(match):
        # plot label in pink and its match in orange
        add_box(get_box(labels, i), 'pink')
        if m == -1:
            continue
        add_box(get_box(preds, m), 'orange')


def plot_all_predictions(match, labels, preds):
    """
    Plots all predictions.
    :param match:   list of preds matching labels: match[i] = j if pred j matches label i
                    -1 if no match, as ints
    :param labels: ground truth in [left x, top y, w, h, ... as ints
    :param preds: predictions in [left x, top y, w, h, ... as ints
    """

    num_real = len(labels)/4
    for i in range(0, num_real):
        add_box(get_box(labels, i), 'pink')
    num_preds = len(preds)/4
    for i in range(0, num_preds):
        if i in match:
            add_box(get_box(preds, i), 'purple')
        else:
            add_box(get_box(preds, i), 'orange')


def add_box(b, edge_color):
    """
    Adds a box to the given figure.
    :param b:           [left x, top y, w, h] as ints
    :param edge_color:  string
    :return:
    """
    current_axis = plt.gca()
    current_axis.add_patch(Rectangle(b[:2], b[2], b[3], facecolor='none', edgecolor=edge_color))
    print(b[:2], b[2], b[3])


def get_box(box_list, i):
    return box_list[4*i: 4+4*i]