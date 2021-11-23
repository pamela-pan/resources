# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)
library(plotly)
library(ggplot2)
library(forecast)

# connect to the apple database
db <- dbConnect(SQLite(), 'pineapple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT distinct prod_type from prods_i')


###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Prediction Plot'),
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
      plotOutput(
        outputId = 'prediction', width='100%', height='500px' )
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session) {
  output$prediction <- renderPlot(
    {
      dy <- dbGetQuery(
        conn = db,
        statement = 
          'SELECT ord_dt as day,
                  sum(price*qty) as sales
            from orders a
               left join order_items b on a.ord_id = b.ord_id
               left join prods_i c on b.prod_id = c.prod_id
            WHERE prod_type = ?
            GROUP BY day
            ORDER BY day DESC',
        params = input$prod_type
      )
      ggplot(dy, aes(x = as.Date(day), y = sales, group = 1)) +
        geom_line(color='red',size = 1) +
        labs(x = 'Day', y = 'Sales') +
        theme_minimal(base_size = 16) +
        theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
        theme(legend.position = 'none')+
        geom_forecast(h=7)
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