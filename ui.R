
library(shiny)   # Web app development
library(haven)   # Read in SAS dataset
library(bslib)   # Provide UI options
library(ggplot2) # Data visualization
library(scales)  # Improve axis labels
library(plotly)  # Interactive graphics
library(readr)
library(dplyr)




dig.df <- read_csv("DIG.csv")
dig.df <- dig.df %>% select(ID, TRTMT, AGE, SEX, BMI, KLEVEL, CREAT, DIABP, SYSBP,
                            HYPERTEN, CVD, WHF, DIG, HOSP, HOSPDAYS, DEATH, DEATHDAY) %>% mutate(across(c(TRTMT, SEX, HYPERTEN, CVD, WHF, DIG, HOSP, DEATH), as.factor), ID = as.character(ID))
#Variables not mutated across remain as numeric <dbl>.
head(dig.df)

dig.df <- dig.df %>%
  mutate(
    TRTMT = factor(TRTMT,
                   levels = c(0, 1),
                   labels = c("Placebo", "Treatment")),
    SEX = factor(SEX,
                 levels = c(1, 2),
                 labels = c("Male", "Female")),
    HYPERTEN = factor(HYPERTEN,
                      levels = c(0, 1),
                      labels = c("No", "Yes")),
    CVD = factor(CVD,
                 levels = c(0, 1),
                 labels = c("No", "Yes")),
    WHF = factor(WHF,
                 levels = c(0, 1),
                 labels = c("No", "Yes")),
    DIG = factor(DIG,
                 levels = c(0, 1),
                 labels = c("No", "Yes")),
    HOSP = factor(HOSP,
                  levels = c(0, 1),
                  labels = c("No", "Yes")),
    DEATH = factor(DEATH,
                   levels = c(0, 1),
                   labels = c("Alive", "Death")))

levels(dig.df$DEATH)

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


