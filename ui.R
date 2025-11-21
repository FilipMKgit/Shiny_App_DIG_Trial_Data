




ui <- fluidPage(
  
<<<<<<< HEAD
=======
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
  
  titlePanel("My Shiny App"),
  
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      p("p creates a paragraph of text."),
      p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.",
        style = "font-family: 'times'; font-16pt"),
      strong("strong() makes bold text."),
      em("em() creates italicized (i.e, emphasized) text."),
      br(),
      code("code displays your text similar to computer code"),
      div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div",
          style = "color:blue"),
      br(),
      p("span does the same thing as div, but it works with",
        span("groups of words", style = "color:blue"),
        "that appear inside a paragraph.")
    )
  ),
  
  
  
  
  
  
>>>>>>> 167f01c3798bedf26d3ad07dec5370fe8f938f48
  navset_tab(
    nav_panel("Welcome",
    
    fluidRow(
      ),
      column(width = 10,
             includeMarkdown("dig_rmd.md")
      )
    )
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
      plotlyOutput("age_count_plot")
     ),
     card(
       card_header("Summary Statistics (Excluding Patients with Missing Data)"),
       tableOutput("summary_table")
     )
   )
  )
 )
)
