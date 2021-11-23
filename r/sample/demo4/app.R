library(shiny)
library(ggthemes)
library(maps)
library(ggplot2)
library(dplyr)

load("map")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "distribution", 
                  label = "Dates:",
                  min = as.Date("2016-01-24","%Y-%m-%d"),
                  max = as.Date("2016-04-02","%Y-%m-%d"),
                  value = as.Date("2016-02-29"), timeFormat="%Y-%m-%d", 
                  step = 1,
                  animate = animationOptions(interval = 1800)),
      br(),
      helpText("How to:", br(),
               "Drag the slider to pick a date.", br(),
               "Press the button below the slider to play animation.", br(), 
               br(),
               "Notes:", br(),
               "Size of the points are weighted by total number of users online in a day.")),
    mainPanel(plotOutput(outputId = "map", height = "70vh"))
  )
)

server <- function(input, output){
  output$map <- renderPlot({
    map %>% 
      filter(date == input$distribution) %>%
      ggplot() +
      borders("world", colour = "gray90", fill = "gray85") +
      theme_map() + 
      geom_point(aes(x = longitude, y = latitude, size = n), 
                 colour = "#351C4D", alpha = 0.55) +
      labs(size = "Users") + 
      ggtitle("Distribution of Users Online") 
  })
}

shinyApp(ui = ui, server = server)