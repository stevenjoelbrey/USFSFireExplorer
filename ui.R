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
                             choices= c("Date Discovered" = "DISCOVERY_DATE",
                                        "Date Contained" = "CONT_DATE",
                                        "Time discovered" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Duration (days)" = "DUR",
                                        "people/km" = "POPULATION_DENSITY"),
                             selected="LONGITUDE"
                 ),
                 
                 selectInput(inputId="yaxis", label="Y Axis",
                             choices= c("Date Discovered" = "DISCOVERY_DATE",
                                        "Date Contained" = "CONT_DATE",
                                        "Time discovered" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Duration (days)" = "DUR",
                                        "people/km" = "POPULATION_DENSITY"),
                             selected="LATITUDE"
                 ),
                 
                 selectInput(inputId="color", label="Color attribute (hist x-axis)",
                             choices= c("Fire Cause" = "STAT_CAUSE_DESCR",
                                        "Cause (binary)" = "cause",
                                        "Month" = "month",
                                        "Date Discovered" = "DISCOVERY_DATE", 
                                        "Time discovered" = "DISCOVERY_TIME",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE", 
                                        "Year" = "year",
                                        "people/km" = "POPULATION_DENSITY",
                                        "none"),
                             selected="STAT_CAUSE_DESCR"),
                 
                 selectInput(inputId="dotSize", label="Size attribute",
                             choices= c("none",
                                        "Fire Size (acres)" = "FIRE_SIZE",
                                        "Fire Latitude" = "LATITUDE", 
                                        "Fire Longitude" = "LONGITUDE",
                                        "people/km" = "POPULATION_DENSITY"
                                        ),
                             selected="FIRE_SIZE"),
                 
                 sliderInput("latRange", 
                             label="Latitude Range:", 
                             min = 17, max = 70, value = c(17, 70)),
                 
                 sliderInput("lonRange", 
                             label="Longitude Range", 
                             min = -170, max = -65, value = c(-170, -65)),
                 
                 sliderInput("minFireSize", 
                             label="Fire size range (acres)", 
                             min = 10, max = 610000, value = c(1000, 606945),
                             step=100),
                 
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
             h3("Welcome the the Fire Program Analysis Fire-Occurrence Database explorer!"),
             p("Explore these data by choosing what you want to see on the axis, color, and size! The default is only a suggestion.
                For example, set the x-axis to discovery date and y axis to fire size to see how reported
                fire sizes are changing versus time. Set the minimum latitude to 50 to see if the
                pattern is the same in Alaska. Happy exploring!"),
             p("The data plotted in this app was downloaded from the link below."),
             tags$a("Reported Fires Data", 
                    href="https://www.fs.usda.gov/rds/archive/Product/RDS-2013-0009.3/"),
             br(),
             tags$a("Paper describing how these data are made", 
                    href="http://www.earth-syst-sci-data.net/6/1/2014/"),
             p("I downloaded the GDB.zip file and extracted the spatial points attributes using ARC-GIS. If you don't have
               a copy feel free to download the .RData spreadsheet version from the Data directory on my github page.
               There are more details about how I choose to subset the data in an R-script I wrote associated with a different
               project."), 
             tags$a("How I subset and originally read in the data", 
                    href="https://github.com/stevenjoelbrey/HMSExplorer/blob/master/R/readUSFSFireOccurance.R"),
             
             h3("Resources:"),
             tags$a("Steven Brey | Ph.D. Student", 
                    href="http://atmos.colostate.edu/~sjbrey/"),
             br(),
             tags$a("Source code on Github",
                    href="https://github.com/stevenjoelbrey/USFSFireExplorer")
    )
  )
))