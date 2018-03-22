# Load the USFS fire data 
df <- get(load("FPA_FOD_1000_acres.RData"))

df$STAT_CAUSE_DESCR <- as.character(df$STAT_CAUSE_DESCR)

# NOTE: MANY OF THESE FIRES DO NOT HAVE A CONT_DATE. Most. 
len <- as.numeric(df$CONT_DATE - df$DISCOVERY_DATE)
dur <- len / (60^2*24)
df$DUR  <- dur

cause <- df$STAT_CAUSE_DESCR
humanMask <- (cause != "Lightning")
cause[humanMask] <- "Anthropogenic"
df$cause <- cause

# TODO: replace with Lubridate::year() and month() functionality 
df$year  <- str_sub(as.character(df$DISCOVERY_DATE), 1, 4)
df$month <- str_sub(as.character(df$DISCOVERY_DATE), 6, 7)


# Make sure we have something that is all the same, just in case 
shinyServer(function(input, output) {

  
  output$scatterPlot <- renderPlotly({

    # Choose what will be displayed from the use 
    xaxis   <- input$xaxis
    yaxis   <- input$yaxis
    colors  <- input$color
    size    <- input$size
    dotSize <- input$dotSize
    minSize <- input$minFireSize[1]
    maxSize <- input$minFireSize[2]
    alaska  <- input$alaska
    
    # Spatial domain subset
    latMask <- df$LATITUDE >= input$latRange[1] & df$LATITUDE <= input$latRange[2]
    lonMask <- df$LONGITUDE >= input$lonRange[1] & df$LONGITUDE <= input$lonRange[2]
    spatialMask <- latMask & lonMask
    
    # Subset the data by size 
    size <- df$FIRE_SIZE
    sizeMask <- size >= minSize & size <= maxSize
    
    # Subset the data by specified date range
    tMin <- as.POSIXct(input$dateRange[1], tz="UTC")
    tMax <- as.POSIXct(input$dateRange[2], tz="UTC")
    tMask <- tMin <= df$DISCOVERY_DATE  & tMax >= df$CONT_DATE
    
    # Subset the dataframe 
    m <-  sizeMask & tMask & spatialMask
    dfp <- df[m, ]
    
    # Set up the plot labels 
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = "#7f7f7f"
    )
    
    x <- list(
      title = xaxis,
      titlefont = f
    )
    
    y <- list(
      title = yaxis,
      titlefont = f,
      exponentformat = "SI"
    )
    
    # p <- plot_ly(dfp, x = dfp[[xaxis]], y = dfp[[yaxis]], 
    #              color = dfp[[colors]], size =dfp[[dotSize]],
    #              text = dfp[['FIRE_NAME']]
    #              ) %>%
    #   layout(xaxis = x, yaxis = y )
    
    # give state boundaries a white border
    l <- list(color = toRGB("white"), width = 2)
    
    # specify some map projection/options
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showland = TRUE,
      landcolor = toRGB("white"),
      subunitwidth = 1,
      countrywidth = 1,
      subunitcolor = toRGB("black"),
      countrycolor = toRGB("black")
    )
    
    # Style the legend
    l <- list(
      font = list(
      family = "sans-serif",
      size = 16,
      color = "#000"),
      bgcolor = "#E2E2E2",
      bordercolor = "#FFFFFF",
      borderwidth = 2)
    
    p <- plot_geo(dfp, locationmode = 'USA-states', sizes = c(1, 250))  %>%
      add_markers(
        y = dfp[[yaxis]], x = dfp[[xaxis]], 
        color = dfp[[colors]], size =dfp[[dotSize]], 
        text = ~paste("Firename:", dfp[["FIRE_NAME"]], "size", dfp[["FIRE_SIZE"]])
      ) %>%
      layout(title = 'Fire Program Analysis Fire Occurrence Data',
             geo=g,
             legend = l)
    
    p
    
  })
  
  output$histogram <- renderPlotly({
    
    # Choose what will be displayed from the use 
    xaxis   <- input$xaxis
    yaxis   <- input$yaxis
    colors  <- input$color
    size    <- input$size
    dotSize <- input$dotSize
    minSize <- input$minFireSize[1]
    maxSize <- input$minFireSize[2]
    alaska  <- input$alaska
    
    # Spatial domain subset
    latMask <- df$LATITUDE >= input$latRange[1] & df$LATITUDE <= input$latRange[2]
    lonMask <- df$LONGITUDE >= input$lonRange[1] & df$LONGITUDE <= input$lonRange[2]
    spatialMask <- latMask & lonMask
    
    # Subset the data by size 
    size <- df$FIRE_SIZE
    sizeMask <- size >= minSize & size <= maxSize
    
    # Subset the data by specified date range
    tMin <- as.POSIXct(input$dateRange[1], tz="UTC")
    tMax <- as.POSIXct(input$dateRange[2], tz="UTC")
    tMask <- tMin <= df$DISCOVERY_DATE  & tMax >= df$CONT_DATE
    
    # Subset the dataframe 
    m <-  sizeMask & tMask & spatialMask
    dfp <- df[m, ]
    
    axisFont <- list(
      family = "Courier New, monospace",
      size = 9,
      color = "#7f7f7f")
    
    axis <- list(
      tickfont = axisFont
    )
    
    p <- plot_ly(dfp, alpha = 1) %>% 
                 add_histogram(x = dfp[[colors]], color = dfp[[colors]]) %>%
      layout(barmode = "overlay", xaxis=axis) %>%
      hide_legend() %>%
      hide_colorbar()
    
    p
    
  })

})
