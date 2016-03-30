
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Twitter Word Cloud"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput("search", "Input search string"),
       submitButton("Submit")
    ),
    
    mainPanel(
       plotOutput("wordcloud")
    )
  )
))
