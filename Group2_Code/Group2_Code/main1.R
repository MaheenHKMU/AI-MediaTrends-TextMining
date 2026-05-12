# ============================================================
#   Topic: “Media Trends in Artificial Intelligence Development and Regulation: A Text Mining Study”
#   Sub Topic: Innovation, Regulation, Ethics, Business
#   Group 2 
# ============================================================


# STEP 1: PACKAGES
# ============================================================

packages <- c(
  "dplyr", "ggplot2", "tidyr", "stringr",
  "wordcloud", "RColorBrewer", "tm", "textstem",
  "officer", "magrittr", "ggplot2"
)

for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
  }
  library(pkg, character.only = TRUE)
}

cat("All packages loaded.\n")


# STEP 2: PATHS
# ============================================================

if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  original_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  original_dir <- getwd()
}

setwd(original_dir)
cat("Working directory:", original_dir, "\n")

output_folder <- file.path(original_dir, "AI_Analysis_Output")
if (!dir.exists(output_folder)) {
  dir.create(output_folder, recursive = TRUE)
}
cat("Output folder:", output_folder, "\n")


# STEP 3: SAFE PNG SAVER 
# ============================================================

save_png <- function(plot_obj, filename, width_in = 10, height_in = 7, res = 200) {
  # 1) Save to PNG file
  filepath <- file.path(output_folder, filename)
  grDevices::png(
    filename = filepath,
    width    = width_in * res,
    height   = height_in * res,
    res      = res
  )
  print(plot_obj)
  grDevices::dev.off()
  if (file.exists(filepath)) {
    cat("  Saved:", filepath, "\n")
  } else {
    warning("  FAILED to save: ", filepath)
  }
  # 2) Also display in RStudio Plots panel
  print(plot_obj)
  return(filepath)
}

save_wordcloud_png <- function(wc_data, filename, title, max_words = 50, res = 150) {
  filepath <- file.path(output_folder, filename)
  if (nrow(wc_data) == 0) {
    cat("  No data for wordcloud:", title, "- skipping\n")
    return(invisible(NULL))
  }
  # 1) Save to PNG file
  grDevices::png(
    filename = filepath,
    width    = 800,
    height   = 800,
    res      = res
  )
  par(mar = c(0, 0, 2, 0))
  tryCatch({
    wordcloud(
      words        = wc_data$Keyword,
      freq         = wc_data$Count,
      max.words    = max_words,
      random.order = FALSE,
      rot.per      = 0.35,
      colors       = brewer.pal(8, "Dark2"),
      scale        = c(3, 0.5)
    )
    title(main = title, cex.main = 1.8)
  }, error = function(e) {
    cat("  Wordcloud error for", title, ":", e$message, "\n")
  })
  grDevices::dev.off()
  if (file.exists(filepath)) cat("  Saved:", filepath, "\n")
  # 2) Also display in RStudio Plots panel
  par(mar = c(0, 0, 2, 0))
  tryCatch({
    wordcloud(
      words        = wc_data$Keyword,
      freq         = wc_data$Count,
      max.words    = max_words,
      random.order = FALSE,
      rot.per      = 0.35,
      colors       = brewer.pal(8, "Dark2"),
      scale        = c(3, 0.5)
    )
    title(main = title, cex.main = 1.8)
  }, error = function(e) {
    cat("  Wordcloud display error for", title, ":", e$message, "\n")
  })
}


# STEP 4: KEYWORDS
# ============================================================

keywords <- list(
  genai = c(
    "synthesizers", "hallucinations", "prompting", "diffusion", "transformers",
    "embeddings", "tokenization", "latents", "checkpoints", "fine-tuning",
    "inpainting", "outpainting", "upscaling", "interpolation", "stylization",
    "remixing", "paraphrasing", "summarization", "translation", "captioning", "intelligence"
  ),
  ml = c(
    "regularization", "optimization", "backpropagation", "quantization", "distillation",
    "pruning", "ensembling", "bootstrapping", "clustering", "classification", "regression",
    "forecasting", "segmentation", "detection", "tracking", "reasoning",
    "grounding", "chaining", "retrieval", "augmentation"
  ),
  robotics = c(
    "actuators", "sensors", "kinematics", "dynamics", "odometry",
    "calibration", "localization", "mapping", "planning", "grasping",
    "manipulation", "locomotion", "navigation", "teleoperation",
    "haptics", "exoskeletons", "drones", "cobots", "grippers", "encoders"
  ),
  laws = c(
    "statutes", "ordinances", "prohibitions", "injunctions", "sanctions",
    "penalties", "liabilities", "compliance", "enforcement", "adjudication",
    "litigation", "arbitration", "legislation", "jurisprudence", "oversight",
    "surveillance", "censorship", "restrictions", "mandates"
  ),
  govt = c(
    "policy", "procurement", "subsidies", "grants", "initiatives", "frameworks",
    "strategies", "roadmaps", "partnerships", "sovereignty", "diplomacy",
    "infrastructure", "innovation", "competitiveness", "autonomy",
    "harmonization", "coordination", "investment", "regulation", "governance"
  ),
  global = c(
    "treaties", "conventions", "protocols", "standards", "certifications",
    "accords", "alliances", "coalitions", "forums", "summits", "councils",
    "committees", "tribunals", "arbitrators", "mediators", "negotiators",
    "diplomats", "envoys", "delegates", "stakeholders",
    "accountability", "cooperation", "inclusion"
  ),
  bias = c(
    "equity", "parity", "justice", "diversity",
    "representation", "calibration", "balance", "neutrality",
    "impartiality", "objectivity", "transparency", "accountability",
    "explainability", "interpretability", "robustness", "security",
    "privacy", "dignity", "rights", "fairness"
  ),
  misinfo = c(
    "forgeries", "fabrications", "counterfeits", "hoaxes",
    "propaganda", "disinformation", "malinformation", "satire",
    "parody", "impersonation", "spoofing", "phishing",
    "scamming", "trolling", "botting", "astroturfing", "clickbait",
    "sensationalism", "conspiracy", "pseudoscience", "influence", "validation"
  ),
  job = c(
    "unemployment", "underemployment", "redundancy", "layoffs", "restructuring",
    "outsourcing", "offshoring", "automation", "mechanization", "computerization",
    "robotization", "reskilling", "upskilling", "retraining", "transitioning",
    "relocating", "migrating", "adapting", "pivoting", "freelancing"
  ),
  business = c(
    "analytics", "forecasting", "optimization", "personalization",
    "recommendation", "targeting", "segmentation", "attribution", "conversion",
    "retention", "acquisition", "engagement", "monetization",
    "scalability", "efficiency", "profitability", "growth", "innovation",
    "transformation"
  ),
  industry = c(
    "deployment", "integration", "implementation", "migration", "modernization",
    "digitization", "virtualization", "containerization", "orchestration",
    "automation", "standardization", "industrialization", "commercialization",
    "commoditization", "democratization", "decentralization", "distribution",
    "dissemination", "proliferation", "saturation"
  ),
  productivity = c(
    "copilots", "assistants", "agents", "chatbots", "scribes", "productivity",
    "notetakers", "schedulers", "planners", "organizers", "summarizers",
    "translators", "transcribers", "researchers", "analysts",
    "designers", "coders", "writers", "editors", "presenters", "collaborators"
  )
)


# STEP 5: TOPIC GROUPINGS
# ============================================================

topics <- list(
  innovation = c("genai", "ml", "robotics"),
  regulation = c("laws", "govt", "global"),
  ethics     = c("bias", "misinfo", "job"),
  business   = c("business", "industry", "productivity")
)

topic_labels <- list(
  innovation = c("Generative AI", "Machine Learning", "Robotics"),
  regulation = c("Laws & Regulations", "Government Strategies", "Global Governance"),
  ethics     = c("Bias & Fairness", "Misinformation", "Job Displacement"),
  business   = c("AI in Business", "Industry Adoption", "AI Productivity")
)

topic_titles <- c("Innovation", "Regulation", "Ethics & Risks", "Business")
topic_colors <- c("#FF9999", "#99CCFF", "#99FF99", "#FFCC99")
bar_colors   <- c("#FF9999", "#99CCFF", "#99FF99")


# STEP 6: READ AND PROCESS TEXT FILES
# ============================================================

file_list <- list.files(path = original_dir, pattern = "\\.txt$", full.names = FALSE)
if (length(file_list) == 0) stop("No .txt files found in: ", original_dir)
cat("Found", length(file_list), "text file(s):", paste(file_list, collapse = ", "), "\n")

count_keyword <- function(text, word) {
  str_count(text, paste0("\\b", word, "\\b"))
}

results  <- data.frame(Document = file_list, stringsAsFactors = FALSE)
all_text <- ""

for (i in seq_along(file_list)) {
  raw  <- paste(readLines(file.path(original_dir, file_list[i]), warn = FALSE), collapse = " ")
  raw  <- tolower(raw)
  raw  <- removeWords(raw, stopwords("en"))
  raw  <- removePunctuation(raw)
  wrds <- unlist(str_split(raw, "\\s+"))
  wrds <- lemmatize_words(wrds)
  wrds <- wrds[nchar(wrds) > 0]
  proc <- paste(wrds, collapse = " ")
  
  all_text <- paste(all_text, proc)
  
  for (cat_name in names(keywords)) {
    results[i, cat_name] <- sum(sapply(keywords[[cat_name]], count_keyword, text = proc))
  }
}

cat("Text processing complete.\n")


# STEP 7: TOTALS
# ============================================================

topic_totals <- list()
for (t in names(topics)) {
  topic_totals[[t]] <- data.frame(
    Category = topic_labels[[t]],
    Count    = as.numeric(colSums(results[, topics[[t]], drop = FALSE]))
  )
}

overall <- data.frame(
  Topic = topic_titles,
  Count = c(
    sum(topic_totals$innovation$Count),
    sum(topic_totals$regulation$Count),
    sum(topic_totals$ethics$Count),
    sum(topic_totals$business$Count)
  )
)
overall$Percentage <- round(100 * overall$Count / sum(overall$Count), 1)
overall$Label      <- paste0(overall$Topic, "\n", overall$Percentage, "%")


# STEP 8: CONSOLE SUMMARY
# ============================================================

cat("\n===== RESULTS BY DOCUMENT =====\n")
print(results)

for (t in names(topics)) {
  cat("\n--- TOPIC:", toupper(t), "---\n")
  print(topic_totals[[t]])
  for (i in seq_along(topics[[t]])) {
    cat_name <- topics[[t]][i]
    wc <- data.frame(
      Keyword = keywords[[cat_name]],
      Count   = sapply(keywords[[cat_name]], count_keyword, text = all_text)
    )
    wc <- wc[wc$Count > 0, ]
    wc <- wc[order(-wc$Count), ]
    cat("  Top 3 in", topic_labels[[t]][i], ":\n")
    for (k in seq_len(min(3, nrow(wc)))) {
      cat(sprintf("    %d. %s (%d)\n", k, wc$Keyword[k], wc$Count[k]))
    }
  }
}


# STEP 9: BAR CHARTS
# ============================================================

cat("\nGenerating bar charts...\n")

for (t in names(topics)) {
  p <- ggplot(topic_totals[[t]], aes(x = Category, y = Count, fill = Category)) +
    geom_col(width = 0.7) +
    geom_text(aes(label = Count), vjust = -0.5, size = 5, fontface = "bold") +
    labs(
      title = paste("Topic:", switch(t,
                                     innovation = "AI Innovation & Technology",
                                     regulation = "AI Regulation & Government Policy",
                                     ethics     = "AI Ethics & Risks",
                                     business   = "AI in Business & Industry"
      )),
      x = "", y = "Total Keyword Mentions"
    ) +
    scale_fill_manual(values = bar_colors) +
    theme_minimal(base_size = 14) +
    theme(
      legend.position    = "none",
      axis.text.x        = element_text(size = 11, face = "bold", color = "black"),
      axis.text.y        = element_text(size = 11, color = "black"),
      axis.title.y       = element_text(size = 13, face = "bold"),
      plot.title         = element_text(size = 15, face = "bold", hjust = 0.5),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank()
    )
  save_png(p, paste0("topic_", t, ".png"))
}

p_comp <- ggplot(overall, aes(x = Topic, y = Count, fill = Topic)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = Count), vjust = -0.5, size = 5, fontface = "bold") +
  labs(title = "All Topics Comparison", x = "", y = "Total Keyword Mentions") +
  scale_fill_manual(values = topic_colors) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position    = "none",
    axis.text.x        = element_text(size = 11, face = "bold", color = "black"),
    axis.text.y        = element_text(size = 11, color = "black"),
    axis.title.y       = element_text(size = 13, face = "bold"),
    plot.title         = element_text(size = 15, face = "bold", hjust = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank()
  )
save_png(p_comp, "topic_comparison.png")

p_pie <- ggplot(overall, aes(x = "", y = Count, fill = Topic)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  geom_text(
    aes(label = Label),
    position  = position_stack(vjust = 0.5),
    size      = 4.5,
    fontface  = "bold"
  ) +
  labs(title = "Topic Coverage Distribution", x = NULL, y = NULL) +
  scale_fill_manual(values = topic_colors) +
  theme_void() +
  theme(
    plot.title      = element_text(hjust = 0.5, face = "bold", size = 15),
    legend.position = "none"
  )
save_png(p_pie, "topic_coverage_pie.png", width_in = 7, height_in = 7)

cat("All bar charts saved.\n")


# STEP 10: WORD CLOUDS
# ============================================================

cat("\nGenerating word clouds...\n")

all_keywords <- data.frame()
for (cat_name in names(keywords)) {
  wc <- data.frame(
    Keyword = keywords[[cat_name]],
    Count   = sapply(keywords[[cat_name]], count_keyword, text = all_text)
  )
  all_keywords <- rbind(all_keywords, wc[wc$Count > 0, ])
}
all_keywords <- aggregate(Count ~ Keyword, all_keywords, sum)
all_keywords <- all_keywords[order(-all_keywords$Count), ]

for (t in names(topics)) {
  wc_data <- data.frame()
  for (cat_name in topics[[t]]) {
    wc <- data.frame(
      Keyword = keywords[[cat_name]],
      Count   = sapply(keywords[[cat_name]], count_keyword, text = all_text)
    )
    wc_data <- rbind(wc_data, wc[wc$Count > 0, ])
  }
  if (nrow(wc_data) > 0) {
    wc_data <- aggregate(Count ~ Keyword, wc_data, sum)
    wc_data <- wc_data[order(-wc_data$Count), ]
    save_wordcloud_png(wc_data,
                       paste0("wordcloud_", t, ".png"),
                       paste("Topic:", t))
  }
}

save_wordcloud_png(all_keywords, "wordcloud_all.png", "All Topics Combined", max_words = 60)
cat("All word clouds saved.\n")


# STEP 11: WORD DOCUMENT
# ============================================================

cat("\nCreating Word document...\n")

top_keyword <- all_keywords[1, ]

add_img_safe <- function(doc, filepath, w = 6, h = 4) {
  if (file.exists(filepath)) {
    doc <- body_add_img(doc, src = filepath, width = w, height = h)
  } else {
    doc <- body_add_par(doc, paste("[Image not found:", basename(filepath), "]"), style = "Normal")
    cat("  WARNING: Missing image:", filepath, "\n")
  }
  return(doc)
}

doc <- read_docx()

doc <- doc %>%
  body_add_par(
    "Media Trends in Artificial Intelligence Development and Regulation: A Text Mining Study",
    style = "heading 1"
  ) %>%
  body_add_par(paste("Analysis Date:", Sys.Date()),          style = "Normal") %>%
  body_add_par(paste("Files Analyzed:", length(file_list)), style = "Normal") %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("EXECUTIVE SUMMARY", style = "heading 2") %>%
  body_add_par(paste("Total keyword mentions across all topics:", sum(overall$Count)), style = "Normal")

for (t in names(topics)) {
  w  <- topic_totals[[t]]$Category[which.max(topic_totals[[t]]$Count)]
  wn <- max(topic_totals[[t]]$Count)
  doc <- body_add_par(doc,
                      paste(" ", toupper(t), "- Most Discussed:", w, "(", wn, "mentions)"),
                      style = "Normal"
  )
}

doc <- doc %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("Overall Topic Ranking:", style = "Normal")

for (i in seq_len(nrow(overall[order(-overall$Count), ]))) {
  row <- overall[order(-overall$Count), ][i, ]
  doc <- body_add_par(doc,
                      paste(" ", i, ".", row$Topic, ":", row$Count, "mentions (", row$Percentage, "%)"),
                      style = "Normal"
  )
}

doc <- doc %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par(
    paste("Most Frequent Keyword Overall:", top_keyword$Keyword, "(", top_keyword$Count, "occurrences)"),
    style = "Normal"
  ) %>%
  body_add_par(" ", style = "Normal")

topic_section_titles <- c(
  innovation = "AI Innovation & Technology",
  regulation = "AI Regulation & Government Policy",
  ethics     = "AI Ethics & Risks",
  business   = "AI in Business & Industry"
)

for (idx in seq_along(names(topics))) {
  t          <- names(topics)[idx]
  t_title    <- topic_section_titles[[t]]
  t_data     <- topic_totals[[t]]
  t_cats     <- topics[[t]]
  t_names    <- topic_labels[[t]]
  
  doc <- doc %>%
    body_add_par(paste("TOPIC", idx, ":", t_title), style = "heading 2") %>%
    body_add_par(" ", style = "Normal") %>%
    body_add_par("Categories discussed:", style = "Normal")
  
  for (i in seq_len(nrow(t_data))) {
    doc <- body_add_par(doc,
                        paste("  -", t_data$Category[i], ":", t_data$Count[i], "mentions"),
                        style = "Normal"
    )
  }
  
  best_cat   <- t_data$Category[which.max(t_data$Count)]
  best_count <- max(t_data$Count)
  doc <- doc %>%
    body_add_par(
      paste("  Most discussed category:", best_cat, "with", best_count, "mentions"),
      style = "Normal"
    ) %>%
    body_add_par(" ", style = "Normal")
  
  for (i in seq_along(t_cats)) {
    wc <- data.frame(
      Keyword = keywords[[t_cats[i]]],
      Count   = sapply(keywords[[t_cats[i]]], count_keyword, text = all_text)
    )
    wc <- wc[wc$Count > 0, ]
    wc <- wc[order(-wc$Count), ]
    doc <- body_add_par(doc, paste("Top 3 keywords in", t_names[i], ":"), style = "Normal")
    for (k in seq_len(min(3, nrow(wc)))) {
      doc <- body_add_par(doc,
                          paste("   ", k, ".", wc$Keyword[k], "(", wc$Count[k], ")"),
                          style = "Normal"
      )
    }
    doc <- body_add_par(doc, " ", style = "Normal")
  }
  
  img_path <- file.path(output_folder, paste0("topic_", t, ".png"))
  doc <- body_add_par(doc, paste(t_title, "- Keyword Chart:"), style = "Normal")
  doc <- add_img_safe(doc, img_path)
  doc <- doc %>%
    body_add_par(paste("Figure", idx, ": Keyword distribution across", t_title), style = "Normal") %>%
    body_add_par(" ", style = "Normal")
}

doc <- doc %>%
  body_add_par("OVERALL TOPIC COMPARISON", style = "heading 2") %>%
  body_add_par(" ", style = "Normal")

for (i in seq_len(nrow(overall))) {
  doc <- body_add_par(doc,
                      paste("  -", overall$Topic[i], ":", overall$Count[i], "mentions (", overall$Percentage[i], "%)"),
                      style = "Normal"
  )
}

doc <- doc %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("Comparison Bar Chart:", style = "Normal")
doc <- add_img_safe(doc, file.path(output_folder, "topic_comparison.png"))
doc <- doc %>%
  body_add_par("Figure 5: Total keyword mentions across all topics", style = "Normal") %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("TOPIC COVERAGE DISTRIBUTION", style = "heading 2") %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("Pie chart - percentage distribution of all topics:", style = "Normal")
doc <- add_img_safe(doc, file.path(output_folder, "topic_coverage_pie.png"), w = 5, h = 5)
doc <- doc %>%
  body_add_par("Figure 6: Topic coverage distribution", style = "Normal") %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("INTERPRETATION", style = "heading 2") %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par(
    paste("Dominant topic:", overall$Topic[which.max(overall$Count)],
          "with", max(overall$Percentage), "% of all keyword mentions."),
    style = "Normal"
  ) %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par("Topic-Specific Insights:", style = "Normal")

for (t in names(topics)) {
  w  <- topic_totals[[t]]$Category[which.max(topic_totals[[t]]$Count)]
  wn <- max(topic_totals[[t]]$Count)
  doc <- body_add_par(doc,
                      paste("  -", topic_section_titles[[t]], ":", w, "with", wn, "mentions."),
                      style = "Normal"
  )
}

doc <- doc %>%
  body_add_par(" ", style = "Normal") %>%
  body_add_par(
    paste("Most frequent keyword overall: '", top_keyword$Keyword,
          "' with", top_keyword$Count, "occurrences."),
    style = "Normal"
  )

docx_path <- file.path(output_folder, "AI_Analysis_Report.docx")
print(doc, target = docx_path)
cat("Word document saved:", docx_path, "\n")


# STEP 12: FINAL SUMMARY
# ============================================================

cat("\n========================================\n")
cat("              FINAL SUMMARY             \n")
cat("========================================\n")
cat("TOPIC WINNERS:\n")
for (t in names(topics)) {
  w  <- topic_totals[[t]]$Category[which.max(topic_totals[[t]]$Count)]
  wn <- max(topic_totals[[t]]$Count)
  cat(sprintf("  %-12s : %s (%d mentions)\n", t, w, wn))
}

cat("\nOVERALL TOPIC COVERAGE:\n")
for (i in seq_len(nrow(overall[order(-overall$Count), ]))) {
  row <- overall[order(-overall$Count), ][i, ]
  cat(sprintf("  %d. %-15s : %d mentions (%.1f%%)\n",
              i, row$Topic, row$Count, row$Percentage))
}

cat(sprintf("\nMOST FREQUENT KEYWORD: %s (%d occurrences)\n",
            all_keywords$Keyword[1], all_keywords$Count[1]))

cat("\nAll outputs saved to:", output_folder, "\n")
cat("\nFiles saved:\n")
for (f in c(
  "topic_innovation.png", "topic_regulation.png",
  "topic_ethics.png",     "topic_business.png",
  "topic_comparison.png", "topic_coverage_pie.png",
  "wordcloud_innovation.png", "wordcloud_regulation.png",
  "wordcloud_ethics.png",     "wordcloud_business.png",
  "wordcloud_all.png",        "AI_Analysis_Report.docx"
)) {
  status <- if (file.exists(file.path(output_folder, f))) "OK" else "MISSING"
  cat(sprintf("  [%s] %s\n", status, f))
}