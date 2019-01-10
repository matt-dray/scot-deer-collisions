# Deer-vehicle collisions in Scotland, 2000 to 2017: a Shiny app
# UI and Server
# Matt Dray
# January 2019


# Global ------------------------------------------------------------------

# Load packages
library(shiny)  # interactive app framework
library(shinydashboard)  # layout
library(leaflet)  # interactive map
library(DT)  # interactive table
library(dplyr)  # data manipulation

# Read pre-prepared data
dvc <- readRDS("data/dvc_sample.RDS")


# UI ----------------------------------------------------------------------


ui <- dashboardPage(
    
    dashboardHeader(
        title = "Deer-vehicle collisions in Scotland, 2000 to 2017"
    ),  # end dashboardHeader
    
    dashboardSidebar(
        selectInput(
            inputId = "input_year", 
            label = "Year",
            choices = unique(dvc$year),
            multiple = TRUE
        ),
        selectInput(
            inputId = "input_month", 
            label = "Month",
            choices = unique(dvc$inc_month),
            multiple = TRUE
        ),
        dateRangeInput(
            inputId = "input_daterange",
            label = "Date range",
            start = min(dvc$inc_date, na.rm = TRUE),
            end = max(dvc$inc_date, na.rm = TRUE),
            min = min(dvc$inc_date, na.rm = TRUE),
            max = max(dvc$inc_date, na.rm = TRUE),
            startview = "decade",
            #weekstart = 1,
            separator = " to "
        ),
        selectInput(
            inputId = "input_la", 
            label = "Local authority",
            choices = unique(dvc$localautho),
            multiple = TRUE
        ),
        selectInput(
            inputId = "input_road", 
            label = "Road",
            choices = unique(dvc$road_no),
            multiple = TRUE
        ),
        selectInput(
            inputId = "input_species", 
            label = "Deer species",
            choices = unique(dvc$deer_speci),
            multiple = TRUE
        )
    ),  # end dashboardSidebar
    
    dashboardBody(
        fluidRow(
            box(leafletOutput("output_map"), width = 12),  # full width
            box(dataTableOutput("output_table"), width = 12)
        )
    )  # end dashboardBody
    
)  # end of ui dashboardPage


# Server ------------------------------------------------------------------


server <- function(input, output) {
    
    # Interactive map with Leaflet
    output$output_map <- renderLeaflet({
        dvc %>%
            filter(
                year %in% input$input_year
                # inc_month %in% input$input_month,
                # localautho %in% input$input_la,
                # road_no %in% input$input_road,
                # deer_speci %in% input$input$species
            ) %>% 
            leaflet() %>% 
            addProviderTiles(providers$OpenStreetMap) %>% 
            addAwesomeMarkers(
                icon = awesomeIcons(
                    iconColor = "#FFFFFF",
                    markerColor = "darkblue"
                )
            )
    })  # end of renderLeaflet
    
    # Interactive map with Leaflet
    output$output_table <- renderDataTable({
        dvc %>% 
            filter(
                year %in% input$input_year
            ) %>% 
            select(inc_date, year, inc_month, localautho, road_no, deer_speci) %>% 
            datatable()
    })  # end of renderDataTable
    
}  # end of server function


# Run ---------------------------------------------------------------------


shinyApp(ui, server)