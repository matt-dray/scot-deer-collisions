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
library(sf)  # geography

# Read pre-prepared data
dvc <- readRDS("data/dvc.rds")

# Month order for dropdown input
mo_order <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")


# UI ----------------------------------------------------------------------


ui <- dashboardPage(
    
    dashboardHeader(
        title = "Deer-vehicle collisions in Scotland, 2000 to 2017",
        titleWidth = 450
    ),  # end dashboardHeader
    
    dashboardSidebar(
        selectInput(
            inputId = "input_year", 
            label = "Year",
            choices = sort(unique(dvc$year)),
            multiple = TRUE,
            selected = sample(unique(dvc$year), 1)
        ),
        selectInput(
            inputId = "input_month", 
            label = "Month",
            choices = unique(dvc$inc_month[order(match(dvc$inc_month, mo_order))]),
            multiple = TRUE,
            selected = sample(unique(dvc$inc_month), 3)
        ),
        selectInput(
            inputId = "input_la", 
            label = "Local authority",
            choices = sort(unique(dvc$localautho)),
            multiple = TRUE,
            selected = sample(unique(dvc$localautho), 3)
        )
    ),  # end dashboardSidebar
    
    dashboardBody(
        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
        fluidRow(
            box(leafletOutput("output_map"), width = 12),
            valueBoxOutput("output_valueselection"),
            valueBoxOutput("output_valueyearla"),
            valueBoxOutput("output_valueyear"),
            box(dataTableOutput("output_table"), width = 12)
        )
    )  # end dashboardBody
    
)  # end of ui dashboardPage


# Server ------------------------------------------------------------------


server <- function(input, output) {
    
    # Value box - year
    output$output_valueyear <- renderValueBox({
        shinydashboard::valueBox(
            value = dvc %>% st_drop_geometry() %>% filter(year %in% input$input_year) %>% count() %>% pull(),
            subtitle = "Collisions in selected year(s)",
            icon = icon("calendar", lib = "font-awesome"),
            color = "blue",
            width = 4
        )
    })  # end of renderValueBox
    
    # Value box - year by la
    output$output_valueyearla <- renderValueBox({
        shinydashboard::valueBox(
            value = dvc %>% st_drop_geometry() %>% filter(year %in% input$input_year, localautho %in% input$input_la) %>% count() %>% pull(),
            subtitle = "Collisions in selected LA(s) in selected year(s)",
            icon = icon("map-o", lib = "font-awesome"),
            color = "blue",
            width = 4
        )
    })  # end of renderValueBox
    
    # Value box - total in your selection
    output$output_valueselection <- renderValueBox({
        shinydashboard::valueBox(
            value = dvc %>% st_drop_geometry() %>% filter(year %in% input$input_year, inc_month %in% input$input_month, localautho %in% input$input_la) %>% count() %>% pull(),
            subtitle = "Collisions in your selection",
            icon = icon("car", lib = "font-awesome"),
            color = "blue",
            width = 4
        )
    })  # end of renderValueBox
    
    # Interactive map with Leaflet
    output$output_map <- renderLeaflet({
      dvc %>%
        filter(
          year %in% input$input_year,
          inc_month %in% input$input_month,
          localautho %in% input$input_la
        ) %>% 
        leaflet() %>% 
        addProviderTiles(providers$OpenStreetMap) %>% 
        addAwesomeMarkers(
          icon = awesomeIcons(
            icon = "fa-car",
            iconColor = "#FFFFFF",
            library = "fa",
            markerColor = "darkblue"
          ),
          popup = ~paste0(
            "<style>
            td, th {
              text-align: left;
              padding: 3px;
            }
            </style>",
            "<table>",
            "<tr>","<td>", "Date", "</td>", "<td>", inc_date, "</td>", "<tr>",
            "<tr>","<td>", "LA", "</td>", "<td>", localautho, "</td>", "<tr>",
            "<tr>","<td>", "Road", "</td>", "<td>", road_no, "</td>", "<tr>",
            "<tr>","<td>", "Species", "</td>", "<td>", deer_speci, "</td>", "<tr>",
            "</table>"
          )
          
          
        )
    })  # end of renderLeaflet
      
      # Interactive table with DT
      output$output_table <- renderDataTable({
        dvc %>% 
            st_drop_geometry() %>%
            filter(
                year %in% input$input_year,
                inc_month %in% input$input_month,
                localautho %in% input$input_la
            ) %>%
            select(
                Date = inc_date,
                Year = year,
                Month = inc_month,
                `Local authority` = localautho,
                Road = road_no,
                `Deer species` = deer_speci
            ) %>%
            datatable(
              
              extensions = c("Scroller", "Buttons"),  # scroll instead of paginate
              rownames = FALSE,  # remove row names
              style = "bootstrap",  # style
              width = "100%",  # full width
              class = "compact",
              options = list(
                deferRender = TRUE,
                # scroll
                scrollY = 300,
                scroller = TRUE,
                # button
                autoWidth = TRUE,  # column width consistent when making selections
                dom = "Blfrtip",
                buttons =
                  list(
                    list(
                      extend = "collection",
                      buttons = c("csv", "excel"),  # download extension options
                      text = "Download"  # text to display
                    )
                  )
              )
              
              
            )
    })  # end of renderDataTable
    
}  # end of server function


# Run ---------------------------------------------------------------------


shinyApp(ui, server)