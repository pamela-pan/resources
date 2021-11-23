# the necessary packages
library(DT)
library(RSQLite)
library(shiny)
library(tidyverse)
library(ggplot2)

# connect to the apple database
db <- dbConnect(SQLite(), 'pineapple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT distinct prod_type from prods_i')


###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Plot'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = 'prod_type',
        label = 'Product Type:',
        choices = prodtype$prod_type,
        selected = 'Macbook'
      ),
      br(),
      dateRangeInput(
        inputId = "date_range",
        label = "Date Range:",
        start = "2020-01-01",
        end = "2020-01-31"
      )
    ),
    mainPanel(
      plotOutput(
        outputId = 'playChrt'
      )
    )
  )
)

###############################################
# define the server function
###############################################
server <- function(input, output, session) {
  output$playChrt <- renderPlot(
    {
      d <- dbGetQuery(
        conn = db,
        statement = 
          'SELECT ord_dt as day,
                  sum(qty) as qty,
                  sum(price*qty) as sales
            FROM orders a
               LEFT JOIN order_items b on a.ord_id = b.ord_id
               LEFT JOIN prods_i c on b.prod_id = c.prod_id
            WHERE prod_type = ? and (day BETWEEN ? AND ?)
            GROUP BY day
            ORDER BY day DESC',
        params = list(input$prod_type,
                      format(input$date_range[1], format = "%Y-%m-%d"),
                      format(input$date_range[2], format = "%Y-%m-%d"))
      )
      ggplot(data = d, aes(x = as.Date(day), y = sales, group=1)) +
        geom_col(size = 1) +
        labs(x = 'Day', y = 'Sales Revenues ($)') + 
        theme_minimal(base_size = 16) +
        theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
        theme(legend.position = 'none')
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