




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("Variable", "Digitalis Data",
                  choices = c("Age" = "AGE",
                              "BMI" = "BMI",
                              "Creatine" = "CREAT",
                              "Diastolic BP" = "DIABP",
                              "Systolic BP" = "SYSBP"))),
    mainPanel(
      plotlyOutput("boxplot"),
      
      br(),
      h3("Number of patients by age"),
      plotlyOutput("age_count_plot")
    )
  )
)


