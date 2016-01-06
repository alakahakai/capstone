# R script file for word prediction
library(tm)

unigram <- readRDS("data/unigram.RDS")
bigram <- readRDS("data/bigram.RDS")
trigram <- readRDS("data/trigram.RDS")

lastWord <- function(s) {
  print(s)
  words <- strsplit(s, "\\s+")
  return(sapply(words, function(l) tail(l, 1)))
}

combineWords <- function(words) {
  paste0(words, collapse = ", ")
}

searchNgram <- function(w, d, num.predictions) {
  search.string <- paste0(w, collapse = " ")
  results <- grep(paste0("^", search.string, "\\s", collapse = ""), d$name,
                  ignore.case = TRUE, value = TRUE)
  if (length(results) > 0) {
    return(lastWord(head(results, num.predictions)))
  } else {
    return(NULL)
  }
}

predictWord <- function(text, num.predictions) {
  words <- removePunctuation(strsplit(text, "\\s+")[[1]])
  unigram.results <- head(unigram$name, num.predictions)
  # If no input, use the unigram predictions
  if (length(words) == 0) {
    return(combineWords(unigram.results))
  } else {
    # Get bigram predictions
    bigram.results <- searchNgram(tail(words, 1), bigram, num.predictions)
    if (length(words) < 2) {
      if (length(bigram.results) < num.predictions) {
        # Add unigram results, up to num.predictions
        return(combineWords(head(c(bigram.results, unigram.results), num.predictions)))
      } else {
        return(combineWords(bigram.results))
      }
    } else {
      # Keep the last two words for search, because we only support up to trigram
      words <- tail(words, 2)
      # Search on trigram
      trigram.results <- searchNgram(words, trigram, num.predictions)
      if (length(trigram.results) < num.predictions) {
        # Combined trigram and bigram predictions, with trigram ones at the top
        tribi.results <- union(trigram.results, bigram.results)
        if (length(tribi.results) < num.predictions) {
          # Add unigram results
          return(combineWords(c(tribi.results, unigram.results)))
        } else {
          return(combineWords(tribi.results))
        }
      } else {
        return(combineWords(trigram.results))
      }
    }
  }
}
