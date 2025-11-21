




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "Variable", "Digitalis Data",
        choices = c("Age" = "AGE",
        "BMI" = "BMI",
        "Creatine" = "CREAT",
        "Diastolic BP" = "DIABP",
        "Systolic BP" = "SYSBP")
        ),
   
      radioButtons(
      "dist_type",
      "Distribution Type:",
      choices = c("Density plot" = "density",
                  "Histogram" = "hist"),
      selected = "density"
    )
   ),
    mainPanel(
    card(
      card_header("Boxplots for Baseline Variables"),
      plotlyOutput("boxplot")
     ),
    card(
      card_header("Distributions by treatment groups"),
      plotlyOutput("age_count_plot")
    )
  )
)
)

