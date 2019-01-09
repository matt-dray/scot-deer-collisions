library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)

dvc <- readRDS("data/dvc_sample.RDS")

ui <- dashboardPage(
    dashboardHeader(title = "Deer-vehicle collisions in Scotland, 2000 to 2017"),
    dashboardSidebar(
        selectInput(
            inputId = "input_la", 
            label = "Choose a local authority",
            choices = unique(dvc$localautho),
            multiple = TRUE
        )
    ),
    dashboardBody(
        fluidRow(
            box(leafletOutput("output_map"), width = 12),
            box(dataTableOutput("output_table"), width = 12)
        )
    )  # end dashboardBody
)  # end dashboardPage

server <- function(input, output) {
    
    output$output_map <- renderLeaflet({
        dvc %>%
            filter(localautho %in% input$input_la) %>% 
            leaflet() %>% 
            addProviderTiles(providers$OpenStreetMap) %>% 
            addAwesomeMarkers(
                icon = awesomeIcons(
                    iconColor = "#FFFFFF",
                    markerColor = "darkblue"
                )
            )
    })  # end of renderLeaflet

    output$output_table <- renderDataTable({
        
        dvc %>%
            filter(localautho %in% input$input_la) %>% 
            select(inc_date, year, inc_month, localautho, road_no, deer_speci) %>% 
            datatable()
        
    })  # end of renderDataTable
    
}  # end of server
    


shinyApp(ui, server)