
library(shiny)   # Web app development
library(haven)   # Read in SAS dataset
library(bslib)   # Provide UI options
library(ggplot2) # Data visualization
library(scales)  # Improve axis labels
library(plotly)  # Interactive graphics
library(readr)
library(dplyr)




dig.df <- read_csv("DIG.csv")




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("Variable", "Digitalis Data",
                  choices = c("Age" = "AGE",
                              "BMI" = "BMI",
                              "Klevel" = "KLEVEL",
                              "Diastolic BP" = "DIABP",
                              "Systolic BP" = "SYSBP"))),
    mainPanel(
      plotOutput("boxplot")
      )
  )
)


