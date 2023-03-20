
# Installing all required packages
if(!require("install.load")){
  install.packages("install.load")
}
library(install.load)


install_load("readr", "shiny", "leaflet", "htmltools", "ggplot2", "shinythemes", "shinyWidgets", "ggthemes", "tidyverse", "data.table") 
#install_load("readr", "shiny", "leaflet", "htmltools", "dplyr", "ggplot2", "shinythemes", "shinyWidgets", "ggthemes" )

#load the data
final_data <- read.csv("Final_dataset_group_32.csv")
#final_data <- final_data %>% sample_n(100000)



# Define UI for application
ui <- fluidPage(
  
  # load the r (necessary for the checkbox group)
  tags$head(tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")),             
  
  # Application title
  titlePanel("Production volumes and field failures"),
  
  tags$head(
    tags$style(
      HTML("
        body {
          height: 100%;
          background-color: Lightsteelblue;
        }
        
        /*change the color of the tab text*/
        .nav-tabs>li>a {
          color: black;
        }
      ")
    )
  ),
  
  # create the sidebar layout
  sidebarLayout(
    # create a sidebar panel with input controls
    sidebarPanel(
      
      #input for censoring date
      dateInput("censoring_date", "Censoring date of the analysis", value = max(final_data$earliest_failure_date )), 
      
      # create a date input control for the censoring dater
      dateRangeInput("production_period", "Production period of the vehicles", start = min(final_data$vehicle_production_date), max(final_data$vehicle_production_date)),
      
      # create the checkbox group for the car selection
      checkboxGroupButtons(
        
        inputId = "selected_vehicle_type",
        label = "Choose the vehicle type",
        choices = c("Type 11" = "11","Type 12" = "12"), 
        selected = c("11", "12"),
        individual = TRUE,
        checkIcon = list(
          yes = tags$i(class = "fa fa-circle", style = "color: Lightsteelblue"),
          no = tags$i(class = "fa fa-circle-o", style = "color: Lightsteelblue")
        )
      ),
      
      # add an image to the sidebar panel
      img(src = "https://media.licdn.com/dms/image/C4E0BAQHliuj-kkUZ0g/company-logo_200_200/0/1611768200813?e=1686787200&v=beta&t=4mmNNxQ2OmYnTBlisQ4a2BAqk7_F925U9gSGOHuYmgU",
          height = 200, width = 200, align = "left", style = "padding-top: 30px;")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      
      ##OUTPUT HERE
      tabsetPanel(
        
        #Display the map
        tabPanel("Map",
                 leafletOutput("map"),
                 absolutePanel(
                   top = 250, left = 20,
                   dropdownButton(
                     selectInput(inputId = 'map_selection',
                                 label = 'select which data to show',
                                 choices = c("Production quantities"="a", "Relative number of field failures in relation to production volume"="b"),
                                 selected = "a"
                     ),
                     circle = TRUE, 
                     status = "danger",
                     icon = icon("cog"), 
                     width = "300px",
                     tooltip = tooltipOptions(title = "Click to change the display!")
                   )
                 )
                 
        )
        
        ,
        
        #Display the plot
        tabPanel("Plot",   
                 plotOutput("plot")),
        
        #Display the underlying dataset
        tabPanel("Underlying dataset",
                 DT::DTOutput("table"))
      )
    )
  )
  
)


# Define server logic
server <- function(input, output) {
  
  #adjust the data to the selected values
  selected_data <- reactive({
    final_data %>%
      mutate(earliest_failure_date = as.numeric(as.Date(earliest_failure_date)))%>%
      replace_na(list(earliest_failure_date = 0))%>%
      filter(vehicle_production_date >= input$production_period[1])%>%
      filter(vehicle_production_date <= input$production_period[2])%>%
      filter(earliest_failure_date <= as.numeric(input$censoring_date))%>%
      filter(vehicle_type %in% input$selected_vehicle_type)%>%
      mutate(earliest_failure_date = replace(earliest_failure_date, earliest_failure_date == 0, NA)) %>%
      mutate(earliest_failure_date = as.Date(earliest_failure_date, origin = "1970-01-01"))
    
  })
  
  data_map <- reactive({
    if (input$map_selection == "b")
    {
      group_by(selected_data(), location) %>% summarise(total = sum(is_failure)/n(), latitude, longitude) %>% distinct() 
    }else if (input$map_selection == "a")
    {
      group_by(selected_data(), location) %>% summarise(total = n(), latitude, longitude) %>% distinct() 
    }else
    {
    }
  })
  
  factor <- reactive({
    if (input$map_selection == "b")
    {
      0.01 
    }else if (input$map_selection == "a")
    {
      30000
    }else
    {
    }
  })
  
  
  ## map-function
  output$map <- renderLeaflet({
    #selected_data %>% na.omit() 
    data_map() %>%
      leaflet()%>%
      #map theme
      addProviderTiles(providers$OpenStreetMap.DE) %>%
      #adds circle markers that have a size relative to the total number of cars...?
      addCircleMarkers(lat = ~latitude, lng = ~longitude, label = ~total, radius = ~total/factor())
  })

  
  
  
  
  
  #create the box plot from the selected data
  output$plot <- renderPlot({
    ggplot(selected_data(), aes(as.factor(vehicle_type), time_till_first_failure, fill = as.factor(vehicle_type)))+
      geom_boxplot(na.rm = TRUE)+
      scale_y_continuous(limits = c(0,800)) +
      labs(x = "Vehicle Type", y = "Lifetime in days") +
      ggtitle("Lifetime by Vehicle Type")+
      theme_clean()+
      theme(
        legend.position="none") 
  })
  
  
  #create the table to show the underlying data
  output$table <- DT::renderDT ({
    DT::datatable(final_data) 
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

