library(shiny)
library(shinythemes)

source("global.R")

ui <- 
  navbarPage("Demo", collapsible = TRUE, inverse = TRUE, theme = shinytheme("spacelab"),
             tabPanel("Participation",
                      fluidPage(
                        fluidRow(
                          column(5, offset = 1, 
                                 helpText("Scroll down to start exploring. Click More Stats button to find out more information of each group.", 
                                          style = "font-size:115%;font-style:italic;" ), br())),
                        fluidRow(
                          column(3, offset = 2, br(), br(), 
                                 h1("320", align = "center", style = "font-size: 350%; letter-spacing: 3px;"), 
                                 h3("Student Participants", align = "center", style = "opacity: 0.75;"), br(),
                                 div(actionButton(inputId = "more1", "More Stats"), style = "margin:auto; width:30%;")),
                          column(6, plotOutput(outputId = "g1", height = "400px")),
                          column(1)),
                        fluidRow(
                          column(3, offset = 2, br(), br(),
                                 h1("48", align = "center", style = "font-size: 350%; letter-spacing: 3px;"), 
                                 h3("Countries / Regions of Origin", align = "center", style = "opacity: 0.75;"), br(),
                                 div(actionButton(inputId = "more2", "More Stats"), style = "margin:auto; width:30%;")),
                          column(6, plotOutput(outputId = "g2", height = "400px")),
                          column(1)),
                        fluidRow(
                          column(3, offset = 2, br(), br(),
                                 h1("16", align = "center", style = "font-size: 350%; letter-spacing: 3px;"), 
                                 h3("Majors", align = "center", style = "opacity: 0.75; letter-spacing: 1px;"), br(),
                                 div(actionButton(inputId = "more3", "More Stats"), style = "margin:auto; width:30%;")),
                          column(6, plotOutput(outputId = "g3", height = "600px")),
                          column(1))
                      )),
                      tabPanel("Service Use",
                               fluidPage(
                                 tabsetPanel(
                                   tabPanel("Accessing Website"),
                                   tabPanel("Visiting Library"),
                                   tabPanel("Attending Workshops"),
                                   tabPanel("Exploring Technology")
                                 ))),
                      tabPanel("Space & Study Habits",
                               fluidPage(
                                 tabsetPanel(
                                   tabPanel("Study Habit"),
                                   tabPanel("Space Preference - Mid & Final Terms"),
                                   tabPanel("Space Preference - Most Days"),
                                   tabPanel("Space Preference - Student Submissions")
                                 ))), 
                      tabPanel("Outreach"),
                      tabPanel("About")
                      )
             
server <- function(input, output) {
  #summary
  ##charts
  output$g1 <- renderPlot({plot1})
  output$g2 <- renderPlot({plot2})
  output$g3 <- renderPlot({plot3})
  ##button
  observeEvent(input$more1, {
    showModal(modalDialog(
      renderTable({tb[[1]]}),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  observeEvent(input$more2, {
    showModal(modalDialog(
      renderTable({tb[[2]]}),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  observeEvent(input$more3, {
    showModal(modalDialog(
      renderTable({tb[[3]]}),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}
             
shinyApp(ui = ui, server = server)