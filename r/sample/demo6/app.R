library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)

load("local")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "peak",
        label = "Devicce:",
        choices = c("All types", "Desktop", "Mobile")),
      br(),
      helpText("Notes:", br(), 
               "The ticks on the X axis indicate the due dates.")
    ),
    mainPanel(plotOutput(outputId = "heatmap", height = "70vh"))
  )
)


server <- function(input, output){
  dataInput <- reactive({
    switch(input$peak,  
           "All types" = local %>% filter(device == "all"),
           "Desktop" = local %>% filter(device == "desktop"),
           "Mobile" = local %>% filter(device == "mobile"))
  })
  
  output$heatmap <- renderPlot({
    ggplot(dataInput(), aes(localdate, localhour2)) + 
      geom_tile(aes(fill = n), colour = "white") + 
      scale_fill_gradient(low = "#f3da4c", high = "blue", breaks = seq(0, 13, 2)) +
      scale_x_date(breaks = seq(as.Date("2016-01-26 UTC"), as.Date("2016-04-02 UTC"), "7 days"), date_labels = "%b %d") + 
      scale_y_continuous(breaks = seq(0, 23, 1)) +
      labs(x = "Date", y = "Hour", fill = "Freq of Online Access") +
      ggtitle("Peak Hours of Studying Online (Local Time)") 
  })
}


shinyApp(ui = ui, server = server)