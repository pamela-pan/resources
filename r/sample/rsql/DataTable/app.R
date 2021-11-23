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
  titlePanel('Demo for Data Table'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = 'prod_type',
        label = 'Product Type:',
        choices = unique(prodtype$prod_type),
        selected = 'Macbook'
      ),
      br(),
    ),
    mainPanel(
      dataTableOutput(
        outputId = 'transactions'
      )
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session) {
  output$transactions <- renderDataTable(
      data <- dbGetQuery(
        conn = db,
        statement = paste0(
          'SELECT a.ord_id,
                  ord_dt,
                  cust_id,
                  prod_type,
                  prod_grp,
                  qty,
                  store_name,
                  city,
                  state
            FROM orders a
              LEFT JOIN order_items b on a.ord_id = b.ord_id 
              LEFT JOIN prods_i c on b.prod_id = c.prod_id
              LEFT JOIN stores d on a.store_id = d.store_id
            WHERE prod_type = \'',input$prod_type, '\'
            ORDER BY ord_dt DESC '
        )
      )
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




