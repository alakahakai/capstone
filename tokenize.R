# R Script to pre-process the NLP source files into tokens

library(tm)
library(dplyr)

fileDir <- "/Users/ray/workspace/datascience/capstone/final/en_US"
setwd(fileDir)

blogLines <- scan(file = "en_US.blogs.txt", what = "character", sep = "\n")
blogTokens <- lapply(strsplit(blogLines, "[[:space:]]|[[:punct:]]"),
                     function(t) Filter(function(x) nchar(x) > 0, t))

newsLines <- scan(file = "en_US.news.txt", what = "character", sep = "\n")
newsTokens <- lapply(strsplit(newsLines, "[[:space:]]|[[:punct:]]"),
                     function(t) Filter(function(x) nchar(x) > 0, t))

twitterLines <- scan(file = "en_US.twitter.txt", what = "character", sep = "\n")
twitterTokens <- lapply(strsplit(twitterLines, "[[:space:]]|[[:punct:]]"),
                     function(t) Filter(function(x) nchar(x) > 0, t))

docs <- Corpus(DirSource(fileDir))

