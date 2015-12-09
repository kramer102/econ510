library(shiny)
library(maps)
library(mapproj)

source("helpers.R")
counties <- readRDS("data/counties.rds")


## min needed for shiny app
# shinyServer(function(input, output){
#   
# })

shinyServer(
  function(input, output) {
    
   output$map <- renderPlot({
     data <- switch(input$var,
                    "Percent White" = counties$white,
                    "Percent Black" = counties$black,
                    "Percent Hispanic" = counties$hispanic,
                    "Percent Asian" = counties$asian)
     percent_map(data, color = "darkgreen", legend.title = "census demographics",
                 max = input$range[2], min = input$range[1])
   })
  
})