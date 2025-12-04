
#--------------------------------------------------------------------------------------------
#START OF FUNCTION
server <- function(input, output, session) {
  
  observeEvent(input$Christmas, { #christmas card button on tab 4
    showModal(
      modalDialog(
        title ="🎁🎄🎁 MERRY CHRISTMAS 🎁🎄🎁",
        HTML("
        <p>Thank you for exploring our app, wishing you a very happy Christmas and a peaceful New Year! ☃️❄️🍫<p>
        <p>🦌 Filip & Tom 🦌</p>
             "),
      easyClose = T,
      footer = modalButton("🛷")
      )
    )
  })
  
  observe({ #app looks out for the theme set in tab 1 and adjusts accordingly
    if (input$app_theme == "dark_mode") {
      session$setCurrentTheme(dark_mode)
    } else if (input$app_theme == "fun_mode") {
      session$setCurrentTheme(fun_mode)
    } else {
      session$setCurrentTheme(light_mode)
    }
  })

  
  #filter non-NA age
  data_age <- reactive({
    dig.df %>% 
      filter(!is.na(AGE))
    
  })

#--------------------------------------------------------------------------------------------
#BOX PLOT IN TAB 2
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
  
  #--------------------------------------------------------------------------------------------
  #DENSITY PLOT AND HISTORGRAM FOR TAB 2
  output$age_count_plot <- renderPlotly({
    var <- input$Variable
    
  if (input$dist_type == "density"){
    
    plotdensity <- ggplot(data_age(), aes(x = .data[[input$Variable]])) +
      geom_density(fill = "darkorange", colour = "black", alpha = 0.75) +
      labs(title = "Density Plot by Baseline Variables",
           x = nice_names[[var]],
           y = "Density") +
      theme_classic()
    
    ggplotly(plotdensity)} #density plot
    
  else {
        plothist <- ggplot(data_age(), aes(x = .data[[input$Variable]])) +
          geom_histogram(fill = "tomato", colour = "white", alpha = 0.8) +
          labs(title = "Histogram by Baseline Variables",
               x = nice_names[[var]],
               y = "Count") +
          theme_classic()
        
        ggplotly(plothist) #histogram
    }
  })
  
  #--------------------------------------------------------------------------------------------
  #SUMMARY TAB FOR TAB 2
  output$summary_table <- renderTable({
    data_age() %>% 
      group_by(TRTMT) %>% 
      summarise(
        n = n(),
        Mean = mean(.data[[input$Variable]], na.rm = T),
        sd = sd(.data[[input$Variable]], na.rm = T),
        Median = median(.data[[input$Variable]], na.rm = T),
        IQR = quantile(.data[[input$Variable]], na.rm = T, 0.75) - quantile(.data[[input$Variable]], na.rm = T, 0.25) 
      )
}) #summary table




  #--------------------------------------------------------------------------------------------
  #USER VALUES FOR TAB 3

  observeEvent(input$user_variable, {
    variable <- input$user_variable
    rnge <- range(dig.df[[variable]], na.rm = T)
    average <- mean(rnge)
  
   updateNumericInput(session, "user_value", value = round(average))
})

  output$boxplot_user <- renderPlotly({
    
    var <- input$user_variable
    user_val <- input$user_value
    
    user_bplot <- ggplot(dig.df, aes(x = TRTMT, y = .data[[var]], fill = TRTMT)) +
      geom_boxplot(alpha = 0.8) +
      geom_hline(yintercept = user_val, color = "red3") + #y intercept set as use input
      scale_fill_manual(values = cols1) +
      theme_fivethirtyeight()+
      labs(
        title = paste("User Input Value in Distribution"),
        x = "",
        y = var
      )
    
    ggplotly(user_bplot)

  })
  
  #--------------------------------------------------------------------------------------------
  #DENSITY PLOT FOR TAB 3

  output$user_density <- renderPlotly({
    var <- input$user_variable
    user_val <- input$user_value
    
    if (input$user_dist_type3 == "density"){
      
      plotdensity <- ggplot(data_age(), aes(x = .data[[var]])) +
        geom_density(fill = "darkturquoise", colour = "black") +
        geom_vline(xintercept = user_val,
                   colour = "red3", #x intercept set as user input for density plot
                   linewidth = 1) +
        labs(title = "Density Plot Distribution by Baseline Vraiables",
             x = nice_names[[var]],
             y = "Density")+
        theme_classic() 
      ggplotly(plotdensity)}
    
    else {
      plothist <- ggplot(data_age(), aes(x = .data[[var]])) +
        geom_histogram(fill = "orchid", colour = "white") +
        geom_vline(xintercept = user_val,
                   colour = "red3", #x intercept set as user input for histogram
                   linewidth = 1) +
        labs(
          title = "Histogram Distribution of Baseline Variables",
          x = nice_names[[var]],
          y = "Count") +
        theme_classic()
      
      ggplotly(plothist)
    }
  })
  


  output$user_summary_table <- renderTable({
    var <- input$user_variable
    user_val <- input$user_value
    
    
    df_user <- dig.df %>% filter(!is.na(.data[[var]]))
    cum_proportion <- mean(df_user[[var]] <= user_val)
    
    data.frame(
      "Variable" = nice_names[[var]],
      "User value" = round(user_val, 3),
      "Proportion ≤ user" = round(cum_proportion, 3),
      "Percentile (%)" = round(cum_proportion * 100, 1),
      check.names = FALSE #summary table
    )
  }, rownames = FALSE)
  
  #NICE TEXT BOX FOR TAB 3
  output$user_summary_text <- renderUI({
    var <- input$user_variable
    user_val <- input$user_value
    
    
    AN <- ifelse(nice_names[[var]] == "Age", "An", "A")
    
    df_user <- dig.df %>% filter(!is.na(.data[[var]]))
    cum_proportion <- mean(df_user[[var]] <= user_val)
    percentile <- round(cum_proportion * 100, 1)
    
    HTML(paste0(
      "<div class='alert alert-info' style='font-size:15px;'>",
      AN, " <b>", nice_names[[var]], "</b> of <b>", round(user_val, 1), "</b> ",
      "is higher than about <b>", percentile,
      "%</b> of patients in the DIG trial.",
      "</div>" #text logic for tab 3 interpretation text box
    ))
  })
  #--------------------------------------------------------------------------------------------
  #Hosp Plot for Tab 4
  
 output$Hosp_plot <- renderPlotly({
   
   df_heat <- WHF_Hosp_summary
   
   if (input$hosp_group == "Placebo") {
     df_heat <- df_heat[df_heat$TRTMT == "Placebo", ]
   } else if (input$hosp_group == "Treatment") {
     df_heat <- df_heat[df_heat$TRTMT == "Treatment", ]
   }
   
   plot_heat <- ggplot(df_heat,aes(x = WHF, y = pct_Hosp, fill = n)) +
     scale_fill_gradient(low ="darkslategray1", high ="darkslategray4") +
     geom_tile() +
     facet_wrap(~ TRTMT) +
     labs(
       title = "Hosp. Heatmap by Treatment Group and Wosening Heart Failure",
       x = "Worsening Heart Failure (WHF)",
       y = "Percentage Hospitalized",
       fill = "Count (n)") +
     theme_stata()
   
   ggplotly(plot_heat)
 })
  #--------------------------------------------------------------------------------------------
  #Death Month Plot for Tab 4
  output$death_month_plot <- renderPlotly({
    
    df_death <- Month_dig.df
    
    df_death <- df_death %>%
      filter(Month <= input$death_month_max)
  
    p <- ggplot(
      df_death,
      aes(x = Month, fill = TRTMT, y = after_stat(density))
    ) +
      scale_fill_manual(values = c("royalblue3", "mediumseagreen")) +
      geom_histogram(alpha = 0.5, bins = 25, position = "identity") +
      geom_density(alpha = 0.5) +
      labs(
        title = "Distribution of Death Month",
        subtitle = paste("Showing deaths up to Month:", input$death_month_max),
        x = "Month since Randomisation",
        y = "Density",
        fill = "Treatment Group"
      ) +
      theme_fivethirtyeight() +
      theme(
        axis.title = element_text(size = 14, face = "bold"),  
        axis.title.x = element_text(margin = margin(t = 10)), 
        axis.title.y = element_text(margin = margin(r = 10))
      )
    
    ggplotly(p)
  })
}

