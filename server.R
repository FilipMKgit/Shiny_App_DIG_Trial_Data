library(shiny)   # Web app development
library(haven)   # Read in SAS dataset
library(bslib)   # Provide UI options
library(ggplot2) # Data visualization
library(scales)  # Improve axis labels
library(plotly)# Interactive graphics
library(readr)
library(dplyr)

dig.df <- read_csv("DIG.csv")

dig.df <- dig.df %>%
  mutate(
    TRTMT  = factor(TRTMT, levels = c("0","1"), labels = c("Placebo", "Treatment")),
    SEX = factor(SEX, levels = c("1","2"), labels = c("Male", "Female")),
    HYPERTEN = factor(HYPERTEN, levels = c("0","1"), labels = c("No","Yes")),
    CVD = factor(CVD, levels = c("0","1"), labels = c("No","Yes")),
    WHF = factor(WHF, levels = c("0","1"), labels = c("No","Yes")),
    DIG = factor(DIG, levels = c("0","1"), labels = c("No","Yes")),
    HOSP = factor(HOSP, levels = c("0","1"), labels = c("No","Yes")),
    DEATH = factor(DEATH, levels = c("0","1"), labels = c("Alive","Death"))
  )

dig.df

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
        y = attributes(dig.df[[input$Variable]])
      ) +
      scale_x_discrete(labels = label_wrap(10))
  }, res = 100)
}
