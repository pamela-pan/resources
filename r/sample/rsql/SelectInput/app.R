
# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)

# connect to the apple database
db <- dbConnect(SQLite(), 'apple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT * from prods_i')

###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Select Input'),
  inputPanel(
    selectInput(
      inputId = 'prod_type',
      label = 'Product Type:',
      choices = unique(prodtype$prod_type),
      selected = 'Macbook'
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