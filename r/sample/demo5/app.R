library(shiny)
library(ggplot2)
library(dplyr)

load("resource_day_sum")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "trajectory", 
                  label = "Date Range:",
                  min = as.POSIXct("2016-01-24","%Y-%m-%d"),
                  max = as.POSIXct("2016-04-02","%Y-%m-%d"),
                  value = c(as.POSIXct("2016-02-01"), as.POSIXct("2016-03-21")), timeFormat="%Y-%m-%d", 
                  step = 1), 
      br(), 
      helpText("How to:", br(),
               "Move the slider, or drag the left and right points to select the date range.", br(),
               br(),
               "Notes:", br(),
               "The grey reference lines indicate assignment due dates or exams.")),
    mainPanel(plotOutput(outputId = "lines", height = "70vh"))
  )
)

##
color <- c("#765285","#D1A827","#709FB0", "#849974", "#A0C1B8")

due <- c(as.POSIXct("2016-01-25 UTC"), as.POSIXct("2016-02-01 UTC"), as.POSIXct("2016-02-15 UTC"), 
         as.POSIXct("2016-02-22 UTC"), as.POSIXct("2016-02-29 UTC"), as.POSIXct("2016-03-07 UTC"),
         as.POSIXct("2016-03-14 UTC"), as.POSIXct("2016-03-21 UTC"), as.POSIXct("2016-03-28 UTC"))

server <- function(input, output){
  output$lines <- renderPlot({
    resource_day_sum %>%
      filter(date >= input$trajectory[1] & date <= input$trajectory[2]) %>% 
      ggplot(aes(date, sum, group = resource, colour = resource)) + 
      geom_line(alpha = 0.9, size = 0.65) + 
      scale_x_datetime(breaks = seq(as.POSIXct("2016-01-26 UTC"), as.POSIXct("2016-04-02 UTC"), "7 days"), 
                       date_labels = "%b %d") +
      geom_vline(xintercept = due, alpha = 0.6, size = 0.65, colour = "grey55") +
      scale_colour_manual(values = color, name = "Resource") +
      labs(title = "Time Spent Online Learning", x = "Date", y = "Total Minutes per Day")
  })
}

shinyApp(ui = ui, server = server)