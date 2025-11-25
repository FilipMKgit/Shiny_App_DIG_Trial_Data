
#colour definitions for later
cols1 <- c('Treatment'='orange','Placebo'='pink')

###################################
#server function
server <- function(input, output, session) {
  
  #filter non-NA age
  data_age <- reactive({
    dig.df %>% 
      filter(!is.na(AGE))
    
  })

####################
#box plot tab 2
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
  
  ########
  #density plot and historgram
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
  
  #######
  #summary table
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




#####
#tab 3 user defined

  observeEvent(input$user_variable, {
    variable <- input$user_variable
    rnge <- range(dig.df[[variable]], na.rm = T)
    average <- mean(rnge)
  
   updateNumericInput(session, "user_value", value = round(average))
})
  
<<<<<<< HEAD
  
  
  
  
    output$user_plot <- renderPlotly({
      var <- input$user_variable
      trt <- input$user_trt
      val <- input$user_value
  
      
      
    plot2 <- ggplot(data = dig.df, aes(x = TRTMT, 
                                      y = .data[[]], 
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
=======
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
>>>>>>> 3404630529944b683848b7154280cc12c7856657
  })
}
  
  


