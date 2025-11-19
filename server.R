library(shiny)   # Web app development
library(haven)   # Read in SAS dataset
library(bslib)   # Provide UI options
library(ggplot2) # Data visualization
library(scales)  # Improve axis labels
library(plotly)# Interactive graphics
library(readr)
library(dplyr)

dig.df <- read_csv("DIG.csv")

server <- function(input, output, session) {
  
  output$boxplot <- renderPlot({
    ggplot(data = dig.df, aes(x = TRTMT, 
                            y = .data[[input$Variable]], 
                            fill = TRTMT)) +
      geom_boxplot() +
      geom_jitter(width = 0.3, alpha = 0.4) +
      theme_minimal() +
      theme(legend.position = "none",
            text = element_text(size = 15)) +
      labs(
        title = "Digitalis Data",
        subtitle = "Comparing Treatment Groups",
        x = "",
        y = attributes(adsl[[input$Variable]])
      ) +
      scale_x_discrete(labels = label_wrap(10))
  }, res = 100)
}

shinyApp(ui, server)