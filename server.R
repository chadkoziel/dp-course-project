library(shiny)
library(DMwR)
library(ggplot2)
library(ddalpha)
library(randomForest)
library(caret)

shinyServer(function(input, output) {
     output$plot1 <- renderPlot({

          airquality.imp <- knnImputation(airquality)
          
          inTrain = createDataPartition(airquality.imp$Ozone, p = input$percentage/100)[[1]]
          training <<- airquality.imp[inTrain,]
          testing <<- airquality.imp[-inTrain,]
               
          start.time <- proc.time()[[1]]
               
          fitted <- train(Ozone ~ .,
                         data = training,
                         trainControl = c(method = "repeatedcv",
                                        number = input$cv.number,
                                        repeats = input$cv.repeats,
                                        preProcOptions = (method = c("scale", "center")),
                                        verboseIter = FALSE),
                         method = "rf" )
               
          training.time <- round(proc.time()[[1]]-start.time,2)
               
          airquality.fit <- data.frame(cbind("predicted" = predict( fitted, newdata = testing ),
                                                  "actual" = testing$Ozone))
          fit.rmse <- round(mean(((airquality.fit[,1]-airquality.fit[,2])^2)^0.5),2)
               
          ggplot(airquality.fit, aes(x=predicted,y=actual)) +
               geom_point() +
               geom_smooth(method=lm, se=FALSE) +
               labs(title = paste0("Predicted vs. Actual - ",
                                   input$cv.number,
                                   " crossfolds, ",
                                   input$cv.repeats,
                                   " repeats and ",
                                   input$percentage,
                                   "% allocated to training"),
                       subtitle = paste0("RMSE = ",fit.rmse,", training time = ",training.time," seconds"))
     })
})