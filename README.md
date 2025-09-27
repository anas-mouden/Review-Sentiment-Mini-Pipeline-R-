# Review-Sentiment-Mini-Pipeline-R-
A compact NLP project in R that scores review sentiment, explores how sentiment varies with user ratings, and visualizes the most frequent terms/themes in the most positive and most negative reviews.
What it does

Loads a reviews.csv dataset and samples 1,000 reviews for a quick exploratory run.

Cleans and tokenizes text, removes stopwords/punctuation/numbers.

Maps words to Bing sentiment lexicon and builds:

Unweighted sentiment score per review.

Weighted sentiment score per review, upweighting by Total_thumbsup + 1.

Plots sentiment/weighted-sentiment distributions across Rating buckets.

Extracts top 15 positive/negative reviews (by weighted score) and:

Builds word clouds.

Runs LDA topic modeling (k = 2) to surface key themes.

Stack / Key Packages

dplyr, tidyr, ggplot2, tidytext, tm, topicmodels, wordcloud, wordcloud2
(Uses get_sentiments("bing") from tidytext.)

Data Requirements

Your reviews.csv should include at least:

Time_submitted (YYYY-mm-dd HH:MM:SS)

text (review body; code renames second column to text)

Rating (numeric/ordered categorical)

Total_thumbsup (non-negative integer)

The script samples 1,000 rows and drops the 6th column of the CSV; adjust as needed.

How to run

Install packages (first run only):

install.packages(c("dplyr","ggplot2","tidyr","tidytext","tm","topicmodels","wordcloud","wordcloud2"))


Put reviews.csv in the working directory.

Source the script or run the cells in order.
Reproducibility: set.seed(1) is set for sampling.

Outputs

Boxplots of sentiment and weights by Rating.

Word clouds for top positive/negative review sets.

Top terms from LDA topics for both positive and negative cohorts (printed via terms(..., 10)).

Notes & Gotchas

Make sure tidytext::stop_words is available; otherwise load with data("stop_words") from tidytext.

If you see “invalid POSIXct” warnings, confirm Time_submitted format: '%Y-%m-%d %H:%M:%S'.

Bug fix tip: in the Negative Reviews section, set the corpus from negative_review, not positive_review:

corpus_negative <- Corpus(VectorSource(negative_review$text))


Adjust ylim(c(-10, 10)) on the weighted boxplot if your score magnitudes differ.

For larger datasets, remove the 1,000-row sample or process in chunks.

Why this is useful

Quick end-to-end baseline for review sentiment analysis.

Bridges lexicon methods with engagement-aware weighting and topic modeling to move beyond a single score.

Easy to adapt for dashboards or model features.

Next Steps (Ideas)

Swap/compare lexicons (AFINN, NRC) or add VADER (via Python bridge).

Try stm for structural topic modeling with covariates (e.g., rating buckets).

Calibrate weights with nonlinear transforms of Total_thumbsup.

Add train/test splits and build a supervised classifier to predict Rating.

License

MIT (feel free to adapt for your own projects).
