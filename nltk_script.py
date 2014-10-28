from pandas import *
import numpy as np
import os
import re
from nltk import NaiveBayesClassifier
import nltk.classify
from nltk.tokenize import wordpunct_tokenize
from nltk.corpus import stopwords
from collections import defaultdict
import scipy.io

os.system("/Applications/MATLAB_R2014a.app/bin/matlab -nodisplay -nosplash -nodesktop -r nltk_makedata")

mat = scipy.io.loadmat('nltk_data.mat')

# data_path = os.path.abspath(os.path.join('.', 'data'))
# train_path = os.path.join(data_path,'train')
# test_path = os.path.join(data_path,'test')
# spam_train_path = os.path.join(train_path, 'spam')
# ham_train_path = os.path.join(train_path, 'ham')
# spam_test_path = os.path.join(test_path, 'spam')
# ham_test_path = os.path.join(test_path, 'ham')



# def get_msgdir(path):
#     '''
#     Read all messages from files in a directory into
#     a list where each item is the text of a message. 
    
#     Simply gets a list of e-mail files in a directory,
#     and iterates get_msg() over them.

#     Returns a list of strings.
#     '''
#     filelist = os.listdir(path)
#     filelist = filter(lambda x: x != 'cmds', filelist)
#     all_msgs =[get_msg(os.path.join(path, f)) for f in filelist]
#     return all_msgs

# def get_msg(path):
#     '''
#     Read in the 'message' portion of an e-mail, given
#     its file path. The 'message' text begins after the first
#     blank line; above is header information.

#     Returns a string.
#     '''
#     with open(path, 'rU') as con:
#         msg = con.readlines()
#         first_blank_index = msg.index('\n')
#         msg = msg[(first_blank_index + 1): ]
#         return ''.join(msg) 



# train_spam_messages    = get_msgdir(spam_test_path)
# train_ham_messages = get_msgdir(ham_train_path)

# test_spam_messages    = get_msgdir(spam_test_path)
# test_ham_messages = get_msgdir(ham_test_path)

# def get_msg_words(msg, stopwords = [], strip_html = False):
#     '''
#     Returns the set of unique words contained in an e-mail message. Excludes 
#     any that are in an optionally-provided list. 

#     NLTK's 'wordpunct' tokenizer is used, and this will break contractions.
#     For example, don't -> (don, ', t). Therefore, it's advisable to supply
#     a stopwords list that includes contraction parts, like 'don' and 't'.
#     '''
    
#     # Strip out weird '3D' artefacts.
#     msg = re.sub('3D', '', msg)
    
#     # Strip out html tags and attributes and html character codes,
#     # like &nbsp; and &lt;.
#     if strip_html:
#         msg = re.sub('<(.|\n)*?>', ' ', msg)
#         msg = re.sub('&\w+;', ' ', msg)
    
#     # wordpunct_tokenize doesn't split on underscores. We don't
#     # want to strip them, since the token first_name may be informative
#     # moreso than 'first' and 'name' apart. But there are tokens with long
#     # underscore strings (e.g. 'name_________'). We'll just replace the
#     # multiple underscores with a single one, since 'name_____' is probably
#     # not distinct from 'name___' or 'name_' in identifying spam.
#     msg = re.sub('_+', '_', msg)

#     # Note, remove '=' symbols before tokenizing, since these are
#     # sometimes occur within words to indicate, e.g., line-wrapping.
#     msg_words = set(wordpunct_tokenize(msg.replace('=\n', '').lower()))
     
#     # Get rid of stopwords
#     msg_words = msg_words.difference(stopwords)
    
#     # Get rid of punctuation tokens, numbers, and single letters.
#     msg_words = [w for w in msg_words if re.search('[a-zA-Z]', w) and len(w) > 1]
    
#     return msg_words

# sw = stopwords.words('english')
# sw.extend(['ll', 've'])

# def features_from_messages(messages, label, feature_extractor, **kwargs):
#     '''
#     Make a (features, label) tuple for each message in a list of a certain,
#     label of e-mails ('spam', 'ham') and return a list of these tuples.

#     Note every e-mail in 'messages' should have the same label.
#     '''
#     features_labels = []
#     for msg in messages:
#         features = feature_extractor(msg, **kwargs)
#         features_labels.append((features, label))
#     return features_labels

# def word_indicator(msg, **kwargs):
#     '''
#     Create a dictionary of entries {word: True} for every unique
#     word in a message.

#     Note **kwargs are options to the word-set creator,
#     get_msg_words().
#     '''
#     features = defaultdict(list)
#     msg_words = get_msg_words(msg, **kwargs)
#     for  w in msg_words:
#             features[w] = True
#     return features

# def make_train_test_sets(feature_extractor, **kwargs):
#     '''
#     Make (feature, label) lists for each of the training 
#     and testing lists.
#     '''
#     train_spam = features_from_messages(train_spam_messages, 'spam', 
#                                         feature_extractor, **kwargs)
#     train_ham = features_from_messages(train_ham_messages, 'ham', 
#                                        feature_extractor, **kwargs)
#     train_set = train_spam + train_ham

#     test_spam = features_from_messages(test_spam_messages, 'spam',
#                                        feature_extractor, **kwargs)

#     test_ham = features_from_messages(test_ham_messages, 'ham',
#                                       feature_extractor, **kwargs)

#     return train_set, test_spam, test_ham

# def check_classifier(feature_extractor, **kwargs):
#     '''
#     Train the classifier on the training spam and ham, then check its accuracy
#     on the test data, and show the classifier's most informative features.
#     '''
    
#     # Make training and testing sets of (features, label) data
#     train_set, test_spam, test_ham = \
#         make_train_test_sets(feature_extractor, **kwargs)
    
#     #===============================================
#     # ADD YOUR CODE HERE
#     # Train the classifier on the training set (train_set)
#     # classifier = /your code/
#     # Test accuracy on test spam emails (test_spam) and test ham emails(test_ham)
#     # spam_accuracy = /your code/
#     # Test accuracy on test ham emails (test_spam) and test ham emails(test_ham)
#     # ham_accuracy = /your code/
#     #===============================================
	
#     # How accurate is the classifier on the test sets?
#     print ('Test Spam accuracy: {0:.2f}%'
#        .format(100 * spam_accuracy))
#     print ('Test Ham accuracy: {0:.2f}%'
#        .format(100 * ham_accuracy))

#     # Show the top 20 informative features
#     print classifier.show_most_informative_features(20)


# check_classifier(word_indicator, stopwords = sw)
