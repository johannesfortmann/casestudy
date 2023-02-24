
# Installing all required packages
if(!require("install.load")){
  install.packages("install.load")
}
library(install.load)

## noch durch die benötigten Pakete zu ersetzen
install_load("shiny", "leaflet", "htmltools", "dplyr", "ggplot2", "shinythemes", "shinyWidgets") 



# Define UI for application
ui <- fluidPage(style = "background-color: Lightsteelblue",
  
  # Application title
  titlePanel("Produktionsvolumina und Feldausfälle"),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      ##INPUT HERE
      dateInput("zensierungsdatum", "Zensierungsdatum der Analyse" ),
      dateRangeInput("produktionszeitraum", "Produktionszeitraum der Fahrzeuge"),
      
      ## hierfür fehlen noch die zugrundeliegenden Daten
      checkboxGroupInput("fahrzeugtyp_auswahl", "Auswahl an betrachteten Fahrzeugtypen", choices = list("a","b","c"))
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

