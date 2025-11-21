




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
         ), # Variables to be displayed on boxplot and Density plot
   
       radioButtons( #These buttons allow user to choose density/histogram
       "dist_type",
       "Distribution Type:",
       choices = c("Density plot" = "density",
                  "Histogram" = "hist"),
     )
    ),
     mainPanel( #Main panel will consist of the boxplot as the top card and the density/histogram below
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

