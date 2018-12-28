# Deer-vehicle collisions in Scotland, 2000 to 2017
# User interface
# Dec 2018
# Matt Dray

navbarPage(
  theme = shinytheme("paper"),
  title = paste("Deer-vehicle collisions in Scotland, 2000 to 2017"),
  
  # NAV BAR: INTERACTIVES ----
  
  tabPanel(
    title = "Interactives",
    
    sidebarLayout(
      
      # LEFT SIDEBAR ----
      
      sidebarPanel(
        
        width = 2,
        
        # DROPDOWN: SELECT LA ----
        
        selectInput(
          inputId = "input_la", 
          label = "Choose a local authority",
          choices = unique(dvc$localautho)
        ),
        
        # STATIC TEXT: HELP ----
        
        helpText("Reference to data source")
        
      ),  # end of sidebarPanel
      
      # MAIN PANEL ----
      
      mainPanel(
        
        tabsetPanel(
          type = "tabs",
          
          # TAB: LEAFLET ----
          
          tabPanel(
            title = "Map",
            leafletOutput("output_map")
          ),  # end of tabPanel
          
          # TAB: DATATABLE ----
          
          tabPanel(
            title = "Table",
            dataTableOutput("output_table")
          )  # end of tabPanel
          
        )  # end of tabsetPanel
      )  # end of mainPanel
    )  # end of sidebarLayout
  ),  # end of tabPanel
  
  # NAV BAR: ABOUT THE APP ----
  
  tabPanel(
    title = "About the app",
    HTML("Placeholder")
    )  # end of tabPanel
  
  )  # end of navbarPage