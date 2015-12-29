# Data Science Capstone project
# Quiz 1: Understanding dataset
# Author: Ray Qiu <ray.qiu@gmail.com>
# Date: Dec 9th, 2015

setwd("/Users/ray/workspace/datascience/capstone/final/en_US")

blogs <- readLines("en_US.blogs.txt")
blogs_length <- nchar(blogs)
print(max(blogs_length))

news <- readLines("en_US.news.txt")
news_length <- nchar(news)
print(max(news_length))

tweets <- readLines("en_US.twitter.txt")
tweets_length <- nchar(tweets)
print(max(tweets_length))

love_lines <- sum(grepl(".*love.*", tweets))
hate_lines <- sum(grepl(".*hate.*", tweets))
print(love_lines / hate_lines)

grep(".*biostats.*", tweets, value = TRUE)

sum(grepl("^A computer once beat me at chess, but it was no match for me at kickboxing$", tweets))
