library(shiny)   # Web app development
library(haven)   # Read in SAS dataset
library(bslib)   # Provide UI options
library(ggplot2) # Data visualization
library(scales)  # Improve axis labels
library(plotly)# Interactive graphics
library(readr)
library(dplyr)
library(ggthemes)

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

cols1 <- c('Treatment'='orange','Placebo'='pink')

server <- function(input, output, session) {
  
  output$boxplot <- renderPlotly({
    
    plot <- ggplot(data = dig.df, aes(x = TRTMT, 
                            y = .data[[input$Variable]], 
                            fill = TRTMT)) +
      geom_boxplot() +
      theme_fivethirtyeight() +
      scale_fill_manual(values = cols1)+
      theme(legend.position = "none",
            text = element_text(size = 15)) +
      labs(
        title = "Digitalis Data",
        subtitle = "Comparing Treatment Groups",
        x = "",
        y = attributes(dig.df[[input$Variable]])
      ) +
      scale_x_discrete(labels = label_wrap(10))
     
     p <- ggplotly(plot)


box_traces <- which(sapply(p$x$data, function(tr) tr$type) == "box")

tooltip <- style(
  p,
  hovertemplate = paste(
    "Treatment: %{x}<br>",
    "Median: %{median}<br>",
    "Q1: %{q1}<br>",
    "Q3: %{q3}<br>",
    "Min: %{min}<br>",
    "Max: %{max}<br>",
    "<extra></extra"
  ),
  traces = box_traces
)

    tooltip
  })
}


<<<<<<< HEAD
=======
server2 <- function(input, output, session) {
  
  data <- reactive({
    dig.df %>% 
      filter(!is.na(AGE))
    
  })
  
 output$AGE_density <- renderPlotly({
   plot2 <- ggplot(data(), aes(x = AGE)) +
     geom_density() +
     theme_classic()
   ggplotly(plot2)
   
 }) 
  
  
}


