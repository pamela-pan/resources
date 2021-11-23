library(shiny)
library(shinyalert)

###############################################
# define the ui layout
###############################################
ui <- fluidPage(
  titlePanel('Demo for Popup Message'),
  useShinyalert(),  
  actionButton(inputId = "save", label = "Save")
)

###############################################
# define the server function
###############################################
server <- function(input, output, session) {
  observeEvent(input$save, {
    shinyalert(title = "OK!", 
               text = "Successfully saved to the database.", 
               type = "success")
  })
}

shinyApp(ui, server)