




ui <- fluidPage(
  theme = light_mode,
  
  tags$div(
    tags$h1("Digitalis Trial Shiny",
    style = "font-weight:800; font-size:20px; padding-right:20px; color:steelblue;")
  ),
  navset_tab(
#--------------------------------------------------------------------------------------------
#Welcome Tab    
    
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
    
    tags$h2("Welcome!", style = "color: firebrick;"),
  
  br(),
  radioButtons("app_theme", "Select App Theme:", choices = c("Default" = "light_mode",
  "Dark Mode" = "dark_mode",
  "Sketchy" = "fun_mode"),
  inline = TRUE
  ), #Selecting Theme for entire app
    
    br(),
    tags$h3("About This App"),
    tags$ul(
      tags$li("Explore the summary statistics of the DIG trial using interactive plots and summary tables."),
      tags$li("Input your own values to see how you compare to the sample in the study."),
      tags$li("Explore the outcomes of the trial and how treatment affected this."),
      tags$li("You can do all of this in 3 different themes!")
    ),
  
    br(),
    tags$h3("The Dataset"),
    
    p("The DIG dataset consists of baseline and outcome characteristics from
    the main DIG trial. There were 6800 participants in the trial (Garg et al., 1997)."),

    br(),
    tags$h3("The Drug"), 
    
    img(src = "Digitalis_glycosides.png", width = "300px"),
    br(),
    p("Digitalis is a cardiac glycoside derived from the foxglove plant, 
      a plant who's therapeutic potential was first described by William Withering in 1785. 
      The drug also commonly referred to as digoxin is known for its distinctive steroid nucleus and lactone ring structure seen above (Hauptmann and kelly, 1999)."),
   
    
    ), #Paragraphs Describing app, context of trial and an image of digitalis
#--------------------------------------------------------------------------------------------
#Explore Tab     
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
#--------------------------------------------------------------------------------------------
#User Input Tab  
  nav_panel("User Input",
 sidebarLayout(
   sidebarPanel(
     selectInput(
       "user_variable", "User input",
       choices = c("Age" = "AGE",
                   "BMI" = "BMI",
                   "Creatine" = "CREAT",
                   "Diastolic BP" = "DIABP",
                   "Systolic BP" = "SYSBP") # Variables to be displayed on boxplot and Density plot
     ), 
     numericInput(
       "user_value",
       "User input",
       value = 50
     ), # User can put in their own values
     radioButtons(
       "user_dist_type3",
       "Distribution Type:",
       choices = c("Density plot" = "density",
                   "Histogram" = "hist")
     ), 
     card_header("Interpretation"),
     uiOutput("user_summary_text")
   ),
   mainPanel(
     card(
       plotlyOutput("boxplot_user")
     ),
     card(
       plotlyOutput("user_density")
     ),
     card(
       card_header("Distribution Table of User Input"),
       tableOutput("user_summary_table"),
     )
   )
 )
),
#--------------------------------------------------------------------------------------------
#Outcomes Tab 
  nav_panel("Outcomes",
            sidebarLayout(
              sidebarPanel(
                h4("Outcomes Overview"),
                p("This tab summarises mortality and hospitalization outcomes for different groups from the Digitalis Trial."),
                
                radioButtons(
                  "hosp_group",
                  "Select Treatment Group:",
                  choices = c("Both", "Placebo", "Treatment"),
                  selected = "Both",
                  inline = TRUE
                ),
                sliderInput(
                  "death_month_max",
                  "Show deaths up to month:",
                  min = 0,
                  max = max(Month_dig.df$Month, na.rm = TRUE),
                  value = max(Month_dig.df$Month, na.rm = TRUE),
                  step = 1
                )
                ),
              mainPanel(
                card(
                    card_header("Distribution of Hospitalization Month by Treatment Group"),
                    plotlyOutput("Hosp_plot"),
              
                card(
                    card_header("Distribution of Death Month by Treatment Group"),
                    plotlyOutput("death_month_plot")
                  )
                )
              )
            )
           )
)
)
