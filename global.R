# Deer-vehicle collisions in Scotland, 2000 to 2017: a Shiny app
# Data preparation
# Jan 2018
# Matt Dray

# Load packages -----------------------------------------------------------


# Data manipulation and cleaning
library(dplyr)  # tidy data manipulation
library(stringr)  # string manipulation
library(janitor)  # misc tidy data manipulation
library(lubridate)  # dealing with dates and times
library(sf)  # geography

# tool structure
library(flexdashboard)  # layout of the tool (pages, frames, etc)

# htmlwidgets
library(crosstalk)  # for allowing htmlwidgets to interact with shared data
library(leaflet)  # interactive maps
library(DT)  # interactive tables


# Read and wrangle data ---------------------------------------------------


dvc_read <- st_read(  # read geographic data
  "data/DVC_SCOTLAND_ESRI/DVC_SCOTLAND.shp",  # shapefile stored in repo
  stringsAsFactors = FALSE  # read factor columns as character columns
) %>% 
  st_transform(crs = 4326) %>%  # transform coords to latlong
  clean_names() %>% mutate_if(is.character, tolower) %>%  # simplify strings
  mutate(
    inc_date = ymd(inc_date),  # convert to datetime
    inc_month = case_when(
      inc_month == 1 ~ "JAN",
      inc_month == 2 ~ "FEB",
      inc_month == 3 ~ "MAR",
      inc_month == 4 ~ "APR",
      inc_month == 5 ~ "MAY",
      inc_month == 6 ~ "JUN",
      inc_month == 7 ~ "JUL",
      inc_month == 8 ~ "AUG",
      inc_month == 9 ~ "SEP",
      inc_month == 10 ~ "OCT",
      inc_month == 11 ~ "NOV",
      inc_month == 12 ~ "DEC",
      TRUE ~ "NA"
    ),
    # clean up names (incomplete)
    deer_speci = if_else(deer_speci %in% c("desppnk", "uncl.", "nk"), "unknown", deer_speci),
    localautho = if_else(localautho == "perth & kinross", "perth_and_kinross", localautho),
    road_no = if_else(road_no %in% c("unalloc", "notallocated", "notalloc", "u"), "unknown", road_no),
    road_no = if_else(str_detect(road_no, "x") == TRUE, "unknown", road_no)
  ) %>% 
  # final name clean
  mutate(localautho = str_replace_all(localautho, "_", " ")) %>%  # insert spaces
  mutate_at(vars(deer_speci, localautho, road_no), tools::toTitleCase)  # To Title Case

# extract latlong cols from sf geometry and bind back to df
dvc_xy <- as.data.frame(st_coordinates(dvc_read))
dvc <- bind_cols(dvc_read, dvc_xy) %>% rename(latitude = X, longitude = Y)


# Sample ------------------------------------------------------------------


# create sample for testing the app (50 per year)
dvc_sample <- dvc %>% 
  group_by(year) %>%  # within each year
  sample_n(50)  # random selection


# Shared data -------------------------------------------------------------


# create shared data object for crosstalk
# dvc_sd <- SharedData$new(dvc)
dvc_sd <- SharedData$new(dvc_sample)


# Save objects ------------------------------------------------------------


saveRDS(dvc, "data/dvc.RDS")
saveRDS(dvc_sample, "data/dvc_sample.RDS")
