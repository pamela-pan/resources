# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)
library(shinythemes)

###############################################
# define the ui layout
###############################################
ui <- navbarPage(
      title = 'Demo for Navigation Bar',
      windowTitle = 'Navigation Bar', 
      position = 'fixed-top', 
      collapsible = TRUE, 
      inverse = FALSE, 
      theme = shinytheme('cosmo'), 
      tabPanel(title = 'Overview'),
      tabPanel(title = 'Store Info'),
      tabPanel(title = 'Sales Prediction')
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