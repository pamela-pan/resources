# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)
library(plotly)

# connect to the apple database
db <- dbConnect(SQLite(), 'pineapple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT distinct prod_type from prods_i')


###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Map'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = 'prod_type',
        label = 'Product Type:',
        choices = prodtype$prod_type,
        selected = 'Macbook'
      ),
      br(),
    ),
    mainPanel(
      plotlyOutput(
        outputId = 'stateMap', width='100%', height='600px' )
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session) {
  output$stateMap <- renderPlotly(
    {
      d2 <- dbGetQuery(
        conn = db,
        statement = 
          'SELECT state,
                  sum(price*qty) as sales
             FROM orders a
                LEFT JOIN order_items b ON a.ord_id = b.ord_id
                LEFT JOIN prods_i c ON b.prod_id = c.prod_id
                LEFT JOIN stores d ON a.store_id = d.store_id
            WHERE prod_type = ?
              AND a.store_id != "00000"
            GROUP BY 1
            ORDER BY sales DESC',
        params = input$prod_type
      )
      plot_geo(d2, locationmode = 'USA-states',sizes = c(1, 1000)) %>%
        add_trace(z = ~sales, locations = ~state,
                  color = ~sales, colors = 'Purples') %>%
        colorbar(title = "$ USD") %>%
        layout(title = 'Total Sales Revenues ($): State-Level',
               geo = list(
                 scope = 'usa',
                 projection = list(type = 'albers usa'),
                 showlakes = TRUE,
                 lakecolor = toRGB('white')
               )
        )
    } 
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