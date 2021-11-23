# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)

# connect to the apple database
db <- dbConnect(SQLite(), 'pineapple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT distinct prod_type from prods_i')

###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Well Panel'),
  fluidRow(
  align = 'center',
  ### panel 1
  column(
    width = 4,
    wellPanel(
      style = 'background-color: #696969; color: #ffffff;',
      h4('Number of Orders'),
      htmlOutput(
        outputId = 'nOrders'
      )
    )
  ),
  ### panel 2
  column(
    width = 4,
    wellPanel(
      style = 'background-color: #696969; color: #ffffff; bold = TRUE',
      h4('Sales Revenues'),
      htmlOutput(
        outputId = 'totSales'
      )
    )
  ),
  ### panel 3
  column(
    width = 4,
    wellPanel(
      style = 'background-color: #696969; color: #ffffff;',
      h4('Average Order Value (AOV)'),
      htmlOutput(
        outputId = 'aov'
      )
    )
   )
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      # style = 'background-color: #ffa700; color: #ffffff;',
      selectInput(
        inputId = 'prod_type',
        label = 'Product Type:',
        choices = prodtype$prod_type,
        selected = 'Macbook'),
    ),
    mainPanel(
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session){

  # render the summary metrics shown at the top 
  output$nOrders <- renderText(
    paste0('<h4>', 
            dbGetQuery(
              conn = db, 
              statement = 
                'SELECT sum(qty) 
                   FROM order_items a
                  INNER JOIN  
                   (SELECT * FROM prods_i WHERE prod_type = ?) b 
                  ON a.prod_id = b.prod_id',
              params = input$prod_type
                      ), 
           '</h4>'))
  
  output$totSales <- renderText(
    paste0('<h4>', 
           dbGetQuery(
             conn = db, 
             statement = 
               'SELECT sum(price*qty) 
                  FROM order_items a
                INNER JOIN 
                 (SELECT * from prods_i WHERE prod_type = ?) b 
                ON a.prod_id = b.prod_id',
             params = input$prod_type
                      ), 
           '</h4>'))
  
  output$aov <- renderText(
    paste0('<h4>', 
           dbGetQuery(
             conn = db, 
             statement = 
                'SELECT round(avg(qty*price),2)
                   FROM order_items a
                INNER JOIN 
                 (SELECT * from prods_i WHERE prod_type = ?) b 
                ON a.prod_id = b.prod_id',
             params = input$prod_type
             
                     ), 
           '</h4>')
    )
}
  
  # when exiting app, disconnect from the apple database
  onStop(
    function()
    {
      dbDisconnect(db)
    }
  )

# execute the Shiny app
shinyApp(ui, server)
