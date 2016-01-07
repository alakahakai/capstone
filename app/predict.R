# R script file for word prediction
library(tm)
library(dplyr)

unigram <- readRDS("data/unigram.RDS")
bigram <- readRDS("data/bigram.RDS")
trigram <- readRDS("data/trigram.RDS")
quadgram <- readRDS("data/quadgram.RDS")

lastWord <- function(s) {
  words <- strsplit(s, "\\s+")
  sapply(words, function(l) tail(l, 1))
}

combineWords <- function(words) {
  paste0(words, collapse = ", ")
}

searchNgram <- function(w, d, num.predictions) {
  search.string <- paste0(w, collapse = " ")
  results <- grep(paste0("^", search.string, " ", collapse = ""), d$name,
                  perl = TRUE, value = TRUE)
  if (length(results) > 0) {
    return(lastWord(head(results, num.predictions)))
  } else {
    NULL
  }
}

processSingle <- function(w, n) {
  bigram.results <- searchNgram(w, bigram, n)
  if (length(bigram.results) == n) {
    bigram.results
  } else if (length(bigram.results) < n) {
    # Fill up with unigram results
    c(bigram.results, head(unigram$name, n - length(bigram.results)))
  } else {
    head(bigram.results, n)
  }
}

processDouble <- function(w, n) {
  trigram.results <- searchNgram(w, trigram, n)
  if (length(trigram.results) == n) {
    trigram.results
  } else if (length(trigram.results) < n) {
    # Combined trigram and bigram predictions, with trigram ones at the top
    c(trigram.results, processSingle(tail(w, 1), n - length(trigram.results)))
  } else {
    head(trigram.results, n)
  }
}

processTriple <- function(w, n) {
  quadgram.results <- searchNgram(w, quadgram, n)
  if (length(quadgram.results) == n) {
    quadgram.results
  } else if (length(quadgram.results) < n) {
    # Combined quadgram and trigram predictions, with quadgram ones at the top
    c(quadgram.results, processDouble(tail(w, 2), n - length(quadgram.results)))
  } else {
    head(quadgram.results, n)
  }
}

predictWord <- function(text, num.predictions) {
  words <- text %>%
           strsplit("\\s+") %>%
           unlist %>%
           removePunctuation %>%
           tolower %>%
           removeNumbers
  # If no input, return unigram results
  if (length(words) == 0) {
    combineWords(head(unigram$name, num.predictions))
  } else if (length(words) == 1) {
    combineWords(processSingle(words, num.predictions))
  } else if (length(words) == 2) {
    combineWords(processDouble(tail(words, 2), num.predictions))
  } else {
    combineWords(processTriple(tail(words, 3), num.predictions))
  }
}
