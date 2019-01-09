# Deer-vehicle collisions in Scotland, 2000 to 2017
# Data preparation
# Dec 2018
# Matt Dray

# load packages
library(flexdashboard)
library(dplyr)
library(stringr)
library(janitor)
library(sf)
library(lubridate)
library(crosstalk)
library(leaflet)
library(DT)
library(shiny)
library(shinythemes)

# read and prep data
dvc_read <- st_read(
  "data/DVC_SCOTLAND_ESRI/DVC_SCOTLAND.shp",
  stringsAsFactors = FALSE  # read factor columns as character
) %>% 
  st_transform(crs = 4326) %>%  # transform coords to latlong
  clean_names() %>% mutate_if(is.character, tolower) %>% 
  mutate(
    inc_date = ymd(inc_date),  # convert to datetime
    # clean up names
    deer_speci = if_else(deer_speci == "desppnk", "unknown", deer_speci),
    localautho = if_else(localautho == "perth & kinross", "perth_and_kinross", localautho),
    road_no = if_else(road_no %in% c("unalloc", "notallocated", "notalloc", "u"), "unknown", road_no),
    road_no = if_else(str_detect(road_no, "x") == TRUE, "unknown", road_no)
  )

# extract latlong cols from sf geometry and bind back to df
dvc_xy <- as.data.frame(st_coordinates(dvc_read))

dvc <- bind_cols(
  dvc_read,
  dvc_xy
) %>%
  rename(latitude = X, longitude = Y)

# create sample for testing
dvc_sample <- sample_n(dvc, 200)

# Save the objects
# saveRDS(dvc, "data/dvc.RDS")
# saveRDS(dvc_sample, "data/dvc_sample.RDS")
