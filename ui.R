library(shiny)
library(plotly)
library(stringr)

shinyUI(fluidPage(
  
  # Application title
  #titlePanel("USFS Fire Explorer"),
  
  tabsetPanel(
    
    tabPanel(title=h6("USFS Fire Explorer"),          
             
             # Sidebar with a slider input for number of bins
             sidebarLayout(
               
               sidebarPanel(
                 
                 selectInput(inputId="xaxis", label="X Axis",
                             choices= c("Date Discoverd" = "DISCOVERY_DATE",
                                        "Date Contained" = "CONT_DATE",
                                        "Time discoverd" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Duration (days)" = "DUR"),
                             selected="LONGITUDE"
                 ),
                 
                 selectInput(inputId="yaxis", label="Y Axis",
                             choices= c("Date Discoverd" = "DISCOVERY_DATE",
                                        "Date Contained" = "CONT_DATE",
                                        "Time discoverd" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Duration (days)" = "DUR"),
                             selected="LATITUDE"
                 ),
                 
                 selectInput(inputId="color", label="Color attribute (hist x-axis)",
                             choices= c("Fire Cause" = "STAT_CAUSE_DESCR",
                                        "Cause (binary)" = "cause",
                                        "Month" = "month",
                                        "Date Discoverd" = "DISCOVERY_DATE", 
                                        "Time discoverd" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Year" = "year",
                                        "none"),
                             selected="STAT_CAUSE_DESCR"),
                 
                 selectInput(inputId="dotSize", label="Size attribute",
                             choices= c("none",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE"                                        ),
                             selected="FIRE_SIZE"),
                 
                 sliderInput("latRange", 
                             label="Latitude Range:", 
                             min = 17, max = 70, value = c(17, 70),
                            locale="us"),
                 
                 sliderInput("lonRange", 
                             label="Longitude Range", 
                             min = -170, max = -65, value = c(-170, -65),
                             locale="us"),
                 
                 sliderInput("minFireSize", 
                             label="Fire size range (acres)", 
                             min = 10, max = 610000, value = c(1000, 606945),
                             format="$#,##0", locale="us", step=100),
                 
                 dateRangeInput(inputId='dateRange', label='Date Range',
                                start = '1992-01-01', end='2013-12-31')    
                 
               ), # end of side bar panel
               
               # Show a plot of the generated distribution
               mainPanel(
                 plotlyOutput("scatterPlot", height = "355px", width = "90%"),
                 #br(),
                 plotlyOutput("histogram", height = "280px", width = "90%")
               )
             )
    ),
    
    tabPanel(title=h6("About"), 
             h3("Welcome the the United States Forest Service Fire data explorer!"),
             p("Explore these data by choosing what you want to see on the axis, color, and size! The default is only a suggestion.
                For example, set the x-axis to discovery date and y axis to fire size to see how reported
                fire sizes are changing versus time. Set the minimum latitude to 50 to see if the
                pattern is the same in Alaska. Happy exploring!"),
             p("The data plotted in this app was downloaded from the link below."),
             tags$a("Reported Fires Data", 
                    href="https://www.fs.usda.gov/rds/archive/Product/RDS-2013-0009.3/"),
             
             h3("Resources:"),
             tags$a("Steven Brey | Ph.D. Student", 
                    href="http://atmos.colostate.edu/~sjbrey/"),
             br(),
             tags$a("Source code on Github",
                    href="https://github.com/stevenjoelbrey/USFSFireExplorer")
    )
  )
))