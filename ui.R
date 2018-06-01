library(shiny)
shinyUI(fluidPage(
     titlePanel("Air Quality Prediction"),
     sidebarLayout(
          sidebarPanel(
               h3("Model parameters"),
               sliderInput("percentage", "Percentage allocated to training:", 1, 100, 20),
               sliderInput("cv.number", label="Number of crossfolds:", 1, 10, 2),
               sliderInput("cv.repeats", label="Number of repeats:", 1, 10, 2),
               submitButton("Submit")
          ),
          mainPanel(
               plotOutput("plot1")
          )
     )
))