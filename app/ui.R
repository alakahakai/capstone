# Develop data products
# Project - State County Map
library(shiny)

shinyUI(fluidPage(
  titlePanel("Data Science Capstone Project"),
  h4("Next Word Prediction"),
  h4("Author: Ray Qiu"),
  h4("Date: January 5, 2016"),
  br(),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num.predictions", label = h5("Number of Predictions"),
                  min = 1, max = 10, step = 1, value = 5),
      textInput("words", label = h3("Text input"),
                value = ""),
      textOutput("echo"),
      br(),
      textOutput("text")),
    mainPanel(
      h3("Help Text"),
      br(),
      p("This is the shiny app for the",
        span("Data Science Capstone Project", style = "color:blue"),
        "."),
      br(),
      p("The slider input is used to set ",
        span("how many predictions", style = "color:red"),
        "to output."),
      br(),
      p("Simply input a phrase to see the predictions of the next word.")
    )
  )
))
