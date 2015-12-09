# ui.R

shinyUI(fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    sidebarPanel(h3("Best Bet given SAT"),
                 textInput("text",label=h3("Enter SAT score"),
                 value = "Enter here")),
#       sliderInput("range", label = h3("Range of interest"),
#                 min = 0, max = 100,value = c(0,100))),
    
    mainPanel(
     tableOutput("table")
    )
  )
))