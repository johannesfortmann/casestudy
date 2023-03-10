
# Installing all required packages
if(!require("install.load")){
  install.packages("install.load")
}
library(install.load)

## noch durch die benötigten Pakete zu ersetzen
install_load("readr","shiny", "leaflet", "htmltools", "dplyr", "ggplot2", "shinythemes", "shinyWidgets") 

#load the data
final_data <- read.csv("Final_dataset_group_32.csv")




# Define UI for application
ui <- fluidPage(style = "background-color: Lightsteelblue",
   
  # load the font awesome library (necessary for the checkbox group)
  tags$head(tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")),             
  
  # Application title
  titlePanel("Produktionsvolumina und Feldausfälle"),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      
      dateInput("censoring date", "Censoring date of the analysis", value = max(final_data$vehicle_failure_date )), ##hier earliest_failure_date 
      #input for production period
      dateRangeInput("production_period", "Production period of the vehicles", start = min(final_data$vehicle_production_date), max(final_data$vehicle_production_date)),
      
      
      
      ## hierfür fehlen noch die zugrundeliegenden Daten
      # create the checkbox group for the car selection
      checkboxGroupButtons(
        
        
        inputId = "selected_vehicle_type",
        label = "Choose the vehicle type",
        choices = c("Type 11", "Type 12"),
        individual = TRUE,
        checkIcon = list(
          yes = tags$i(class = "fa fa-circle", style = "color: Lightsteelblue"),
          no = tags$i(class = "fa fa-circle-o", style = "color: Lightsteelblue")
        )
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      
      ##OUTPUT HERE
      tabsetPanel(
        tabPanel("Map",
                 leafletOutput("map")),
        tabPanel("Plot",   
                 plotOutput("plot")),
        tabPanel("Table",
                 tableOutput("table"))
      )
    )
  )
  
)

# Define server logic
server <- function(input, output) {
    
  #adjust the data to the selected values
  selected_data <- final_data# %>%
  #  filter(vehicle_production_date>production_period[1]) 
  
  
  
  ## hier Karte einfügen (nur Platzhalter) 
  output$map <- renderLeaflet({
    leaflet()
  })
  
  
  
  ## hier Plot einfügen (nur Platzhalter)
  output$plot <- renderPlot({
    ggplot()
  })
  
  
  ## hier Tabelle einfügen (nur Platzhalter)
  output$table <- renderTable({
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

