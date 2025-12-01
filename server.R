
#--------------------------------------------------------------------------------------------
#START OF FUNCTION
server <- function(input, output, session) {
  
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
    
  if (input$dist_type == "density"){
    
    plotdensity <- ggplot(data_age(), aes(x = .data[[input$Variable]])) +
      geom_density(fill = "steelblue", colour = "black") +
      theme_classic() 
    ggplotly(plotdensity)}
    
  else {
        plothist <- ggplot(data_age(), aes(x = .data[[input$Variable]])) +
          geom_histogram(fill = "steelblue", colour = "black") +
          labs(title = "Histogram by treatment") +
          theme_classic()
        
        ggplotly(plothist)
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
})




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
      geom_boxplot(alpha = 0.7) +
      geom_hline(yintercept = user_val, color = "firebrick") +
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
  
  plotdensity <- ggplot(dig.df, aes(x = .data[[var]])) +
    geom_density(fill = "steelblue", colour = "black") +
    geom_vline(xintercept = user_val,
               colour = "firebrick") +
    labs(title = "User Input Value in Distribution", x = var, y = "Density") +
    theme_classic() 
  
  ggplotly(plotdensity)
  
})

  output$user_summary_table <- renderTable({
    var <- input$user_variable
    user_val <- input$user_value
    df_user <- dig.df %>% filter(!is.na(.data[[var]]))
    cum_proportion <- mean(df_user[[var]] <= user_val)
    data.frame(
      "Variable" = var,
      "User value" = round(user_val, 3),
      "Proportion ≤ user" = round(cum_proportion, 3),
      "Percentile (%)" = round(cum_proportion * 100, 1),
      check.names = F
    )}, rownames = F)
  
  output$user_summary_text <- renderText({
    var <- input$user_variable
    user_val <- input$user_value
    df_user <- dig.df %>% filter(!is.na(.data[[var]]))
    cum_proportion <- mean(df_user[[var]] <= user_val)
    percentile <- round(cum_proportion * 100, 1)
    paste("For",
          var,
          "=",
          round(user_val, 1),
          "this value is in the",
          percentile,
          "percentile in the data.")
  })
  

  
}

