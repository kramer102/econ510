library(shiny)



appData <- readRDS(
  "/home/robert/all_Robert_asus/prog_asus/R/Project/simple_sat_app/appData.rds")


## min needed for shiny app
# shinyServer(function(input, output){
#   
# })

shinyServer(
  function(input, output) {
    
    output$table <- renderTable({
      data1 <- subset(appData, sat < as.numeric(input$text))
      #data1 <- sort(data1$e50,decreasing = T)
      head(data1)
    })
    
#    output$map <- renderPlot({
#      data <- switch(input$var,
#                     "Percent White" = counties$white,
#                     "Percent Black" = counties$black,
#                     "Percent Hispanic" = counties$hispanic,
#                     "Percent Asian" = counties$asian)
#      percent_map(data, color = "darkgreen", legend.title = "census demographics",
#                  max = input$range[2], min = input$range[1])
#    })
  
})