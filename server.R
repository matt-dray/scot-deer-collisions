# Deer-vehicle collisions in Scotland, 2000 to 2017
# Server
# Dec 2018
# Matt Dray

function(input, output) {

  # TABLE: LEAFLET ----
  
  output$output_map <- renderLeaflet({
    
    dvc %>%
      filter(localautho == input$input_la) %>% 
      leaflet() %>% 
      addProviderTiles(providers$OpenStreetMap) %>% 
      addAwesomeMarkers(
        icon = awesomeIcons(
          iconColor = "#FFFFFF",
          markerColor = "darkblue",
          text = case_when(
            dvc$year == "2000" ~ "00",
            dvc$year == "2001" ~ "01",
            dvc$year == "2002" ~ "02",
            dvc$year == "2003" ~ "03",
            dvc$year == "2004" ~ "04",
            dvc$year == "2005" ~ "05",
            dvc$year == "2006" ~ "06",
            dvc$year == "2007" ~ "07",
            dvc$year == "2008" ~ "08",
            dvc$year == "2009" ~ "09",
            dvc$year == "2010" ~ "10",
            dvc$year == "2011" ~ "11",
            dvc$year == "2012" ~ "12",
            dvc$year == "2013" ~ "13",
            dvc$year == "2014" ~ "14",
            dvc$year == "2015" ~ "15",
            dvc$year == "2016" ~ "16",
            dvc$year == "2017" ~ "17",
            TRUE ~ "NA"
          )
        ),
        popup = ~paste0(
          "<br><b>Date</b>: ", dvc$inc_date,
          "<br><b>LA</b>: ", dvc$localautho,
          "<br><b>Road</b>: ", dvc$road_no
        ),
        clusterOptions = markerClusterOptions()
      )
    
  })  # end of renderLeaflet
  
  # TABLE: DATATABLE ----
  
  output$output_table <- renderDataTable({
    
    dvc %>%
      filter(localautho == input$input_la) %>% 
      select(inc_date, year, inc_month, localautho, road_no, deer_speci) %>% 
      datatable()
    
  })  # end of renderDataTable
  
}