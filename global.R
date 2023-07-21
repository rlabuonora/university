library(fresh)
library(dplyr)
library(shinydashboard)
library(leaflet)
library(htmltools)
library(fresh)
library(DT)

# Create the theme
mytheme <- create_theme(
  adminlte_color(
    light_blue = "#434C5E"
  ),
  adminlte_sidebar(
    width = "400px",
    dark_bg = "#D8DEE9",
    dark_hover_bg = "#81A1C1",
    dark_color = "#2E3440"
  ),
  adminlte_global(
    content_bg = "#FFF",
    box_bg = "#D8DEE9", 
    info_box_bg = "#D8DEE9"
  )
)

# load data

programs_geolocated <- readRDS("./data/programs_geolocated.rds") %>% 
  select(university, longitude, latitude, requirements, study_level, location, program_title, subject,
         study_mode, course_intensity, duration, fee_gbp, toefl, ielts, bachelor_gpa,
         cambridge_cae_advanced, pte_academic, a_levels, international_baccalaureate)

the_ranking_data <- readRDS("./data/the_ranking_data.rds") %>% 
  filter(university != "ESCP Business School - Paris")


# Helper function to filter programs within map bounds
# de bounds
filter_bounds <- function(data, bounds) {
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  subset(data,
         latitude >= latRng[1] & latitude <= latRng[2] &
           longitude >= lngRng[1] & longitude <= lngRng[2])
}

constants <- list(fee=range(programs_geolocated$fee_gbp, na.rm = TRUE))

