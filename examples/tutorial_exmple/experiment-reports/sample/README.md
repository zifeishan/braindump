# Corpus Statsitics
* Number of documents: 14230
* Number of sentences: 55469

# Variables
## Variable has_spouse
* Number of mention candidates: 285340
* Number of positive examples: 23570
* Number of negative examples: 79204
* Number of query variables: 182566
* Number of extracted mentions with >0.9 expectation: 930
* Number of extracted entities with naive entity linking: 471
* Good-Turing estimation of prob. that next extracted mention is new:
  * Estimate: 0.389
  * 95% Confidence interval: [0.000, 1.000]

### Most frequent entities
    Benazir Bhutto-Asif Ali Zardari	45
    Asif Ali Zardari-Benazir Bhutto	42
    Nicolas Sarkozy-Carla Bruni	24
    Carla Bruni-Nicolas Sarkozy	22
    Britney Spears-Kevin Federline	21
    Kevin Federline-Britney Spears	21
    Bill Clinton-Hillary Rodham Clinton	18
    Hillary Rodham Clinton-Bill Clinton	16
    Paul McCartney-Heather Mills	16
    Heather Mills-Paul McCartney	14

# Features
## Top Positive Features
    weight	pos_examples	neg_examples	queries	description
    1.45266	1500	1245	2509	f_has_spouse_features-NGRAM_1_[wife]
    1.40876	1500	1245	2509	f_has_spouse_features-INV_NGRAM_1_[wife]
    1.38993	949	558	880	f_has_spouse_features-NGRAM_1_[husband]
    1.33699	949	558	880	f_has_spouse_features-INV_NGRAM_1_[husband]
    1.27709	401	425	1088	f_has_spouse_features-INV_LENGTHS_[4_2]
    1.22152	401	425	1088	f_has_spouse_features-LENGTHS_[2_4]
    1.16876	487	276	530	f_has_spouse_features-INV_NGRAM_1_[marry]
    1.12548	487	276	530	f_has_spouse_features-NGRAM_1_[marry]
    1.11094	369	453	831	f_has_spouse_features-INV_LENGTHS_[2_4]


## Top Negative Features
    weight	pos_examples	neg_examples	queries	description
    -1.48034	128	4043	12616	f_has_spouse_features-INV_NGRAM_1_[;]
    -1.44639	128	4043	12616	f_has_spouse_features-NGRAM_1_[;]
    -1.31464	11741	39571	91170	f_has_spouse_features-STARTS_WITH_CAPITAL_[True_True]
    -1.15326	6	488	1213	f_has_spouse_features-LENGTHS_[2_0]
    -1.1493	177	2749	7863	f_has_spouse_features-LENGTHS_[1_1]
    -1.1459	0	417	415	f_has_spouse_features-LENGTHS_[0_0]
    -1.10292	177	2749	7863	f_has_spouse_features-INV_LENGTHS_[1_1]
    -1.08472	6	488	1213	f_has_spouse_features-INV_LENGTHS_[0_2]
    -1.07205	1115	7397	12899	f_has_spouse_features-KW_IND_[non_married]

## Feature table has_spouse_features
* Total number of features: 19318524
* Number of distinct features: 3047199
* Good-Turing estimation of prob. that next extracted feature is new:
  * Estimate: 0.107
  * 95% Confidence interval: [0.079, 0.135]

### Most frequent features for has_spouse_features
    IS_INVERTED	142670
    INV_STARTS_WITH_CAPITAL_[True_True]	142482
    STARTS_WITH_CAPITAL_[True_True]	142482
    INV_W_NER_L_1_R_1_[O]_[O]	133569
    W_NER_L_1_R_1_[O]_[O]	133569
    INV_NGRAM_1_[,]	112532
    NGRAM_1_[,]	112532
    INV_W_NER_L_2_R_1_[O O]_[O]	71560
    W_NER_L_2_R_1_[O O]_[O]	71560
    INV_W_NER_L_1_R_2_[O]_[O O]	63443

