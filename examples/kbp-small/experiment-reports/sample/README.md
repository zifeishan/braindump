# Corpus Statsitics
* Number of documents: 1716
* Number of sentences: 70805

# Variables
## Variable relation_mentions
* Number of mention candidates: 347902
* Number of positive examples: 2276
* Number of negative examples: 19179
* Number of query variables: 326447
* Number of extracted mentions with >0.9 expectation: 21857
* Number of extracted entities with naive entity linking: 14654
* Good-Turing estimation of prob. that next extracted mention is new:
  * Estimate: 0.546
  * 95% Confidence interval: [0.000, 1.000]

### Most frequent entities
    hugo chavez	president	per:title	217
    raul castro	president	per:title	112
    george w. bush	president	per:title	107
    fidel castro	president	per:title	69
    samsung	lee	org:founded_by	53
    lee	samsung	per:employee_or_member_of	52
    bush	president	per:title	50
    mahmoud ahmadinejad	president	per:title	48
    raul castro	brother	per:title	41
    heidi montag	spencer pratt	per:spouse	40

# Features
## Top Positive Features
    weight	pos_examples	neg_examples	queries	description
    3.56216	113	1	6629	relation_mention_lr-per:title_IND_STARTS_WITH_CAPITAL_%|%True%|%False
    2.60625	95	0	5043	relation_mention_lr-per:title_IND_INV_STARTS_WITH_CAPITAL_%|%True%|%False
    1.97282	478	0	3335	relation_mention_lr-per:title_SEQ_INV_LEMMA_%|%
    1.97282	478	0	3335	relation_mention_lr-per:title_SEQ_INV_POS_%|%
    1.97282	478	0	3335	relation_mention_lr-per:title_SEQ_INV_WORD_%|%
    1.97282	478	0	3335	relation_mention_lr-per:title_SEQ_INV_NER_%|%
    1.88952	19	6	111	relation_mention_lr-per:siblings_SEQ_INV_NGRAM_1_%|%~!sister
    1.8115	42	0	176	relation_mention_lr-per:title_LEN_LENGTHS_%|%12%|%9
    1.56022	208	0	296	relation_mention_lr-per:title_LEN_INV_LENGTHS_%|%11%|%9

* WARNING: many top features may get a high weight because of not enough negative examples:
  * relation_mention_lr-per:title_IND_STARTS_WITH_CAPITAL_%|%True%|%False
  * relation_mention_lr-per:title_IND_INV_STARTS_WITH_CAPITAL_%|%True%|%False
  * relation_mention_lr-per:siblings_SEQ_INV_NGRAM_1_%|%~!sister
  * relation_mention_lr-per:title_LEN_LENGTHS_%|%12%|%9

## Top Negative Features
    weight	pos_examples	neg_examples	queries	description
    -3.69625	36	679	1220	relation_mention_lr-per:title_IND_STARTS_WITH_CAPITAL_%|%True%|%True
    -2.72648	494	648	3097	relation_mention_lr-per:title_IND_INV_STARTS_WITH_CAPITAL_%|%True%|%True
    -2.58513	0	604	18118	relation_mention_lr-per:other_family_IND_STARTS_WITH_CAPITAL_%|%True%|%True
    -2.42349	0	113	20	relation_mention_lr-per:employee_or_member_of_IND_STARTS_WITH_CAPITAL_%|%True%|%False
    -2.3409	0	1158	18167	relation_mention_lr-per:other_family_IND_IS_INVERTED
    -2.19697	1	113	31	relation_mention_lr-per:spouse_IND_STARTS_WITH_CAPITAL_%|%True%|%False
    -2.17794	59	1107	18167	relation_mention_lr-per:children_IND_IS_INVERTED
    -2.01673	48	1116	18167	relation_mention_lr-per:parents_IND_IS_INVERTED
    -2.01146	0	114	31	relation_mention_lr-per:siblings_IND_STARTS_WITH_CAPITAL_%|%True%|%False

## Feature table relation_mention_features
* Total number of features: 8368916
* Number of distinct features: 2167463
* Good-Turing estimation of prob. that next extracted feature is new:
  * Estimate: 0.181
  * 95% Confidence interval: [0.141, 0.222]

### Most frequent features for relation_mention_features
    IND_IS_INVERTED	69974
    SEQ_WIN_NER_L_1_R_1_%|%O%|%O	66826
    SEQ_INV_WIN_NER_L_1_R_1_%|%O%|%O	61495
    IND_STARTS_WITH_CAPITAL_%|%True%|%True	54425
    IND_INV_STARTS_WITH_CAPITAL_%|%True%|%True	51576
    SEQ_WIN_NER_L_2_R_1_%|%O@|@O%|%O	48771
    SEQ_INV_WIN_NER_L_2_R_1_%|%O@|@O%|%O	45029
    SEQ_NGRAM_1_%|%~!,	44917
    SEQ_WIN_NER_L_1_R_2_%|%O%|%O@|@O	43862
    SEQ_INV_WIN_NER_L_1_R_2_%|%O%|%O@|@O	40579

