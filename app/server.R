library(shiny)
library(sp)

source("predict.R")

shinyServer(
  function(input, output){
    getWords <- reactive({
      trimws(input$words)
    })
    output$echo <- renderText({
      if (nchar(getWords()) > 0) {
        paste0("You entered text: ", getWords())
      } else {
        "No text entered (leading and trailing whitespaces eliminated)"
      }
    })
    result <- reactive({
      predictWord(getWords(), input$num.predictions)
    })
    output$text <- renderText({
      paste("Predicted word(s) (in probability descending order):", result())
    })
  }
)
