
# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)
library(plotly)


###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Date Range'),
  inputPanel(
    dateRangeInput(
      inputId = "time_range",
      label = "Time Range:",
      start = "2020-01-01",
      end = "2020-01-31"
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session)
  

  # when exiting app, disconnect from the apple database
  onStop(
    function()
    {
      dbDisconnect(db)
    }
  )

# execute the Shiny app
shinyApp(ui, server)