library(RSQLite)
library(shiny)
library(tidyverse)
library(shinyalert)

# connect to the apple database
db <- dbConnect(SQLite(), 'pineapple.db') #--db needs updating
prodtype <- dbGetQuery(db, 'SELECT distinct prod_type from prods_i')


###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Create Table'),
  column(6,
    selectInput(
        inputId = 'prod_type',
        label = 'Product Type:',
        choices = prodtype$prod_type,
        selected = 'Macbook'
        )
  ),
  column(6,
    useShinyalert(),  
    actionButton(inputId = "save", 
                 label = "Save"),
    align = 'right'
  ),
  hr(),
  dataTableOutput(outputId = 'store')
)


###############################################
# define the server function
###############################################
server <- function(input, output, session){
  output$store <- renderDataTable(
    data <- dbGetQuery(
      conn = db,
      statement = 
        'SELECT city, d.store_name,
                     sum(price*qty) as sales
               FROM orders a
                  left join order_items b on a.ord_id = b.ord_id
                  left join prods_i c on b.prod_id = c.prod_id
                  left join stores d on a.store_id = d.store_id
               WHERE prod_type = ? and a.store_id != "00000"
               GROUP BY 1,2
               ORDER BY sales DESC
               LIMIT 10', 
      params = input$prod_type
    )
  )
  
  observeEvent(input$save, {
    dbGetQuery(
      conn = db,
      statement = paste0(
        'DROP TABLE IF EXISTS top10_store_',input$prod_type)
    )
  }
  )
  
  observeEvent(input$save, {
          dbGetQuery(
            conn = db,
            statement = paste0(
              'CREATE TABLE top10_store_',input$prod_type,' AS
               SELECT city, d.store_name,
                     sum(price*qty) as sales
               FROM orders a
                  left join order_items b on a.ord_id = b.ord_id
                  left join prods_i c on b.prod_id = c.prod_id
                  left join stores d on a.store_id = d.store_id
               WHERE prod_type = ? and a.store_id != "00000"
               GROUP BY 1,2
               ORDER BY sales DESC
               LIMIT 10'),
            params = input$prod_type
          )
      }
    )
  
  observeEvent(input$save, {
    shinyalert(title = "OK!", 
               text = "Successfully saved to the database.", 
               type = "success")
  })

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
