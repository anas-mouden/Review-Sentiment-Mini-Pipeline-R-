# 📊 Review Sentiment Analysis in R

A compact NLP pipeline for analyzing customer reviews using R.  
This project scores sentiment, compares it against review ratings, and visualizes positive/negative themes with word clouds and topic modeling.

---

## 🚀 Features
- Load and preprocess text reviews (`reviews.csv`)
- Clean, tokenize, and remove stopwords/punctuation/numbers
- Map words to **Bing lexicon** sentiments
- Compute:
  - Raw sentiment score per review
  - Weighted sentiment (scaled by `Total_thumbsup + 1`)
- Visualize with:
  - Sentiment distribution by rating (boxplots)
  - Word clouds for most positive/negative reviews
  - LDA topic models (k = 2) to extract themes

---

## 🛠️ Tech Stack
- **Language:** R  
- **Libraries:**  
  `dplyr`, `ggplot2`, `tidyr`, `tidytext`, `tm`, `topicmodels`, `wordcloud`, `wordcloud2`

---

## 📂 Data Requirements
Your `reviews.csv` should contain:
- `Time_submitted` → format `%Y-%m-%d %H:%M:%S`  
- `text` → review body (renamed from 2nd column)  
- `Rating` → numeric or categorical rating  
- `Total_thumbsup` → non-negative integer  

⚠️ The script samples **1,000 reviews** from the dataset. Remove sampling for full-scale runs.

---

## ▶️ How to Run
1. Install dependencies:
   ```r
   install.packages(c("dplyr","ggplot2","tidyr","tidytext","tm","topicmodels","wordcloud","wordcloud2"))
