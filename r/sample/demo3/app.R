library(shiny)
library(shinythemes)
library(ggplot2)

source("global.R")

ui <- 
  navbarPage("Demo", selected = "Service Use", collapsible = TRUE, inverse = TRUE, theme = shinytheme("spacelab"),
             tabPanel("Participation"),
             tabPanel("Service Use",
                      fluidPage(
                        tabsetPanel(
                          tabPanel("Accessing Website", br(),
                                   sidebarLayout(
                                     sidebarPanel(
                                       radioButtons(
                                         inputId = "question1",
                                         label = "Choose a question to explore",
                                         choices = c("Email/chat with library staff", 
                                                     "Find books", 
                                                     "Search for articles", 
                                                     "Use subject / citation guides",
                                                     "Book a group study room")), br(),
                                       radioButtons(
                                         inputId = "group1",
                                         label = "Choose a dimension to explore",
                                         choices = c("Student Status", "Country / Region of Origin", "Major")), br(),
                                       radioButtons(
                                         inputId = "plot1",
                                         label = "Choose a plot type to explore",
                                         choices = c("Stacked Bars", "Grouped Bar Charts", "Stacked Bars (Percent)"))),
                                     mainPanel(plotOutput(outputId = "plot_access_web", height = "600px"))
                                   )),
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
  groupInput <- reactive({
    switch(input$group1,
           "Student Status" = survey$status, 
           "Country / Region of Origin" = survey$country, 
           "Major" = survey$major)
  })
  dataInput <- reactive({
    switch(input$question1, 
           "Email/chat with library staff" = survey$Q1.1_2, 
           "Find books" = survey$Q1.1_7, 
           "Search for articles" = survey$Q1.1_4, 
           "Use subject / citation guides" = survey$Q1.1_6,
           "Book a group study room" = survey$Q1.1_3)
  })
  output$plot_access_web <- renderPlot({
    if (input$plot1 == "Stacked Bars") {
      ggplot(survey, aes(groupInput())) + 
        geom_bar(aes(fill = dataInput()), position = position_stack(reverse = TRUE), width = 0.4, alpha = 0.75) +
        scale_fill_manual(values = c(palette[[1]][4], palette[[2]][1], palette[[3]][1])) +
        scale_x_discrete(limits = rev(levels(groupInput()))) +
        coord_flip() +
        theme(axis.text.x = element_text(size = 15),
              axis.text.y = element_text(size = 15, margin = margin(0,3,0,0)),
              axis.title.y = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_line(size = 0),
              legend.title = element_blank(),
              legend.text = element_text(size = 15),
              plot.margin = unit(c(1,2,2,3), "cm")) 
    } else if (input$plot1 == "Grouped Bar Charts") {
      ggplot(survey, aes(groupInput())) + 
        geom_bar(aes(fill = dataInput()), position = "dodge", width = 0.6, alpha = 0.75) +
        scale_fill_manual(values = c(palette[[1]][4], palette[[2]][1], palette[[3]][1])) +
        scale_x_discrete(limits = rev(levels(groupInput()))) +
        coord_flip() +
        theme(axis.text.x = element_text(size = 15),
              axis.text.y = element_text(size = 15, margin = margin(0,3,0,0)),
              axis.title.y = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_line(size = 0),
              legend.title = element_blank(),
              legend.text = element_text(size = 15),
              plot.margin = unit(c(1,2,2,3), "cm")) 
    } else if (input$plot1 == "Stacked Bars (Percent)") {
      ggplot(survey, aes(groupInput())) + 
        geom_bar(aes(fill = dataInput()), position = "fill", width = 0.3, alpha = 0.75) +
        scale_fill_manual(values = c(palette[[1]][4], palette[[2]][1], palette[[3]][1])) +
        scale_x_discrete(limits = rev(levels(groupInput()))) +
        coord_flip() +
        theme(axis.text.x = element_text(size = 15),
              axis.text.y = element_text(size = 15, margin = margin(0,3,0,0)),
              axis.title.y = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_line(size = 0),
              legend.title = element_blank(),
              legend.text = element_text(size = 15),
              plot.margin = unit(c(1,2,2,3), "cm")) 
    }
  })
}

shinyApp(ui = ui, server = server)
