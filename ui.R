




ui <- fluidPage(
  navset_tab(
    
    
    nav_panel("Welcome",
    tags$head(
    tags$style(HTML("
            code {
                display:block;
                padding:9.5px;
                margin:0 0 10px;
                margin-top:10px;
                font-size:13px;
                line-height:20px;
                word-break:break-all;
                word-wrap:break-word;
                white-space:pre-wrap;
                background-color:#F5F5F5;
                border:1px solid rgba(0,0,0,0.15);
                border-radius:4px; 
                font-family:monospace;
            }"))
  ),
    
    tags$h2("Shiny Application for Digitalis Trial", style = "color: firebrick;"),
    
    p("This Shiny Application explores the DIG Trial was a randomized, double-blind,
    multicenter trial with more than 300 centers. The aim of the trial was to assess
    the efficacy and tolerability of Digitalis for the treatment of congestive heart failure."),
    
    strong("Dataset"),
    
    p("The DIG dataset consists of baseline and outcome characteristics from
    the main DIG trial. There were 6800 participants in the trial (Garg et al., 1997)."),
  
    p("Our app explores the baseline characteristics of the trial through the lens of the user. 
      The first tab shows visualisations of the summary statistics of this trial, including boxplots, density plots and a summary table. 
      Tab 2 allows the user to input their own baseline characteristics and see how they would compare against the distributions of other patients within the trial. 
      Finally, Tab 3 shows the outcome of the trial in terms of hozpitalizations and mortality."),
  
    img(src = "Digitalis_glycosides.png")
    
    ),
    
    nav_panel("Explore",
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
      plotlyOutput("age_count_plot") #Change this later as it is for all variables
     ),
     card(
       card_header("Summary Statistics (Excluding Patients with Missing Data)"),
       tableOutput("summary_table")
     )
   )
  )
 ),
 
  nav_panel("User Input",
 sidebarLayout(
   sidebarPanel(
     selectInput(
       "user_variable", "User input",
       choices = c("Age" = "AGE",
                   "BMI" = "BMI",
                   "Creatine" = "CREAT",
                   "Diastolic BP" = "DIABP",
                   "Systolic BP" = "SYSBP")
     ), 
     numericInput(
       "user_value",
       "User input",
       value = 50
     )
   ),
   mainPanel(
     card(
       card_header("Boxplots for Baseline Variables and User Input"),
       plotlyOutput("boxplot_user")
     ),
     card(
       card_header("Distributions by Treatment groups with User Input"),
       plotlyOutput("user_density")
     )
   )
 )
)
)
)


