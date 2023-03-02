
# Installing all required packages
if(!require("install.load")){
  install.packages("install.load")
}
library(install.load)

## noch durch die benötigten Pakete zu ersetzen
install_load("shiny", "leaflet", "htmltools", "dplyr", "ggplot2", "shinythemes", "shinyWidgets") 



# Define UI for application
ui <- fluidPage(style = "background-color: Lightsteelblue",
   
  # load the font awesome library (necessary for the checkbox group)
  tags$head(tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")),             
  
  # Application title
  titlePanel("Produktionsvolumina und Feldausfälle"),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      ##INPUT HERE
      dateInput("zensierungsdatum", "Zensierungsdatum der Analyse" ),
      dateRangeInput("produktionszeitraum", "Produktionszeitraum der Fahrzeuge"),
      
      
      
      ## hierfür fehlen noch die zugrundeliegenden Daten
      # create the checkbox group for the car selection
      checkboxGroupButtons(
        
        
        inputId = "fahrzeugtyp_auswahl",
        label = "Auswahl an betrachteten Fahrzeugtypen",
        choices = c("Option 1", "Option 2", "Option 3", "Option 4"),
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
        tabPanel("Karte",
                 leafletOutput("map")),
        tabPanel("Plot",   
                 plotOutput("plot")),
        tabPanel("Tabelle",
                 tableOutput("table"))
      )
    )
  )
  
)

# Define server logic
server <- function(input, output) {
  
  
  
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

