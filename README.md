# AI Trends TextMining

> Text mining and keyword frequency analysis of AI development and regulation trends using R. Classifies 13 articles across 4 themes: Business, Regulation, Innovation, and Ethics & Risks. Built for STAT 2610SEF Group Project (2026).

---

## 📖 Table of Contents

- [About the Project](#about-the-project)
- [Key Findings](#key-findings)
- [Repository Structure](#repository-structure)
- [Dataset](#dataset)
- [Methodology](#methodology)
- [How to Run](#how-to-run)
- [Tools & Technologies](#tools--technologies)
- [Outputs](#outputs)
- [Course Info](#course-info)

---

## About the Project

This project applies **keyword-based text mining** to a curated corpus of 13 academic and industry articles on artificial intelligence, implemented entirely in **R**. The study maps how AI-related themes are distributed across contemporary research and professional literature by classifying text across **4 major topics** and **12 subcategories**.

The project was completed as part of the STAT 2610SEF Data Analytics With Applications course (2026 Spring).

---

## Key Findings

A total of **4,405 keyword mentions** were recorded across the 13 articles.

| Rank | Topic | Mentions | Share |
|:---:|---|:---:|:---:|
| 1 | 💼 Business & Industry | 1,500 | 34.1% |
| 2 | 📜 Regulation & Government Policy | 1,045 | 23.7% |
| 3 | 🚀 Innovation & Technology | 987 | 22.4% |
| 4 | ⚖️ Ethics & Risks | 873 | 19.8% |
| | **Total** | **4,405** | **100%** |

**Subcategory highlights:**

- 🔥 **Generative AI** dominated Innovation — **812 mentions** (82.3% of topic total)
- 📋 **Government Strategies** led Regulation — **808 mentions**
- ⚖️ **Bias & Fairness** led Ethics & Risks — **492 mentions**
- 📈 Most frequent single keyword: **"intelligence"** with **764 occurrences**
- 🤖 **"automation"** appeared in both Business and Ethics, reflecting its dual role in AI discourse as both a commercial driver and a source of labour market concern

---

## Repository Structure

```
AI-Trends-TextMining/
│
├── README.md
├── .gitignore
│
├── code/
│   └── main1.R                      ← Full R source code
│
├── data/
│   ├── 01.txt                       ← Article 01
│   ├── 02.txt                       ← Article 02
│   ├── 03.txt                       ← Article 03
│   ├── 04.txt                       ← Article 04
│   ├── 05.txt                       ← Article 05
│   ├── 06.txt                       ← Article 06
│   ├── 07.txt                       ← Article 07
│   ├── 08.txt                       ← Article 08
│   ├── 09.txt                       ← Article 09
│   ├── 10.txt                       ← Article 10
│   ├── 11.txt                       ← Article 11
│   ├── 12.txt                       ← Article 12
│   └── 13.txt                       ← Article 13
│
├── output/
│   ├── topic_comparison.png         ← Bar chart: all 4 topics compared
│   ├── topic_coverage_pie.png       ← Pie chart: topic % distribution
│   ├── topic_innovation.png         ← Bar chart: Innovation subcategories
│   ├── topic_regulation.png         ← Bar chart: Regulation subcategories
│   ├── topic_ethics.png             ← Bar chart: Ethics subcategories
│   ├── topic_business.png           ← Bar chart: Business subcategories
│   ├── wordcloud_all.png            ← Word cloud: all topics combined
│   ├── wordcloud_innovation.png     ← Word cloud: Innovation topic
│   ├── wordcloud_regulation.png     ← Word cloud: Regulation topic
│   ├── wordcloud_ethics.png         ← Word cloud: Ethics topic
│   ├── wordcloud_business.png       ← Word cloud: Business topic
│   └── AI_Analysis_Report.docx     ← Auto-generated R output summary
│
└── report/
    └── STAT2610_Group2_FinalReport.docx   ← Full 7,000-word academic report
```

---

## Dataset

The corpus consists of **13 plain text articles**, each containing a minimum of 2,000 words, sourced from peer-reviewed journals, industry research reports, and policy publications (2003–2025). Articles were selected to ensure balanced thematic coverage across all four topics.

**Article titles:**

1. Machine Learning: A Revolution of News Writing and Digital Era
2. Agents, Robots, and Us: Skill Partnerships in the Age of AI
3. Generative AI and News Report 2025
4. Artificial Intelligence Regulation: A Framework for Governance
5. Artificial Intelligence in the European Union: Policy, Ethics and Regulation
6. AI and Law: A Fruitful Synergy
7. Characterizing AI-Generated Misinformation on Social Media
8. A Review of Bias and Fairness in Artificial Intelligence
9. Eco-Innovation and Financial Performance Nexus: Does Company Size Matter?
10. The GenAI Divide: State of AI in Business 2025
11. Rise of Artificial Intelligence in Business and Industry
12. Opportunities and Adoption Challenges of AI in the Construction Industry
13. The Impact of Artificial Intelligence on Productivity, Distribution and Growth

---

## Methodology

The analysis pipeline consists of four stages, all implemented in R:

### 1. Text Pre-processing
- **Case normalisation** — all text converted to lowercase via `tolower()`
- **Stop-word removal** — common English function words removed using `tm::removeWords()`
- **Punctuation removal** — via `tm::removePunctuation()`
- **Lemmatisation** — words reduced to base forms using `textstem::lemmatize_words()`

### 2. Keyword Dictionary Design
A hierarchical keyword taxonomy was manually curated across **4 topics** and **12 subcategories**, each containing ~20 domain-specific terms:

| Topic | Subcategories |
|---|---|
| Innovation | Generative AI · Machine Learning · Robotics |
| Regulation | Laws & Regulations · Government Strategies · Global Governance |
| Ethics & Risks | Bias & Fairness · Misinformation · Job Displacement |
| Business | AI in Business · Industry Adoption · AI Productivity |

### 3. Classification & Counting
- Keyword matching via `stringr::str_count()` with **word-boundary regex** (`\b`) to prevent partial matches
- Counts computed per article and aggregated across the full corpus
- Topic-level totals derived by summing subcategory counts

### 4. Visualisation
- **Bar charts** (per topic + overall comparison) — `ggplot2`
- **Pie chart** (topic % distribution) — `ggplot2` with `coord_polar()`
- **Word clouds** (per topic + combined) — `wordcloud` + `RColorBrewer`
- **Auto-generated summary report** — `officer`

---

## How to Run

### Prerequisites

Install R from [https://www.r-project.org](https://www.r-project.org), then install the required packages:

```r
install.packages(c(
  "dplyr", "ggplot2", "tidyr", "stringr",
  "wordcloud", "RColorBrewer", "tm", "textstem",
  "officer", "magrittr"
))
```

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/YOUR-USERNAME/AI-Trends-TextMining.git
cd AI-Trends-TextMining
```

**2. Open RStudio** and set your working directory to the `code/` folder:
```r
setwd("path/to/AI-Trends-TextMining/code")
```

**3. Run the script**
```r
source("main1.R")
```

**4. Check the output**

All charts, word clouds, and the summary report will be saved automatically to the `output/` folder.

> ⚠️ **Note:** The `data/` folder must be present and all 13 `.txt` files must be intact before running the script.

---

## Tools & Technologies

| Tool | Version | Purpose |
|---|---|---|
| R | 4.3.3 | Core programming language |
| tm | — | Text preprocessing |
| textstem | — | Lemmatisation |
| stringr | — | Keyword matching (regex) |
| ggplot2 | — | Bar charts and pie chart |
| wordcloud | — | Word cloud generation |
| RColorBrewer | — | Word cloud colour palettes |
| officer | — | Auto-generated Word document |
| dplyr / tidyr | — | Data manipulation |

---

## Outputs

The R script automatically generates **12 output files** saved to the `output/` folder:

| File | Type | Description |
|---|---|---|
| `topic_comparison.png` | Bar chart | All 4 topics compared by total keyword mentions |
| `topic_coverage_pie.png` | Pie chart | Percentage distribution across 4 topics |
| `topic_innovation.png` | Bar chart | Innovation subcategory breakdown |
| `topic_regulation.png` | Bar chart | Regulation subcategory breakdown |
| `topic_ethics.png` | Bar chart | Ethics & Risks subcategory breakdown |
| `topic_business.png` | Bar chart | Business subcategory breakdown |
| `wordcloud_all.png` | Word cloud | All topics combined |
| `wordcloud_innovation.png` | Word cloud | Innovation topic keywords |
| `wordcloud_regulation.png` | Word cloud | Regulation topic keywords |
| `wordcloud_ethics.png` | Word cloud | Ethics topic keywords |
| `wordcloud_business.png` | Word cloud | Business topic keywords |
| `AI_Analysis_Report.docx` | Word doc | Auto-generated summary report |

---

## Course Info

| | |
|---|---|
| **Course** | STAT 2610SEF — Data Analytics With Applications |
| **Semester** | 2026 Spring |
| **Group** | Group 2 (8 members) |
| **Submission** | April 2026 |
