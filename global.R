library(fresh)
library(dplyr)
library(shinydashboard)
library(leaflet)
library(htmltools)
library(fresh)
library(DT)
library(htmltools)
library(stringr)
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


# Helper function to filter programs within map bounds
# de bounds
filter_bounds <- function(data, bounds) {
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  stopifnot("latitude" %in% colnames(data))
  
  subset(data,
         latitude >= latRng[1] & latitude <= latRng[2] &
           longitude >= lngRng[1] & longitude <= lngRng[2])
}


# load data

programs_geolocated <- readRDS("./data/programs_geolocated.rds") %>% 
  select(university, longitude, latitude, requirements, study_level, location, program_title, subject,
         study_mode, requirements, course_intensity, duration_length, fee_gbp, toefl, ielts, bachelor_gpa,
         cambridge_cae_advanced, pte_academic, a_levels, international_baccalaureate) %>% 
  mutate(course_intensity=if_else(is.na(course_intensity), "N/A", course_intensity)) %>% 
  mutate(study_mode=if_else(is.na(study_mode), "N/A", study_mode)) %>% 
  filter(university != "ESCP Business School - Paris")
# clean toefl and ielts


locations_initial <- programs_geolocated %>% 
  group_by(university, longitude, latitude) 
  
universities <- readRDS("./data/universities.rds") %>% 
  ungroup() %>% 
  mutate(rank=if_else(rank=="Reporter", NA, rank)) %>% 
  mutate(rank_sort=str_remove(rank, "=")) %>% 
  mutate(rank_sort=as.numeric(str_remove(rank_sort, "–\\d{3,4}"))) %>% 
  select(-longitude, -latitude) %>% 
  select(-programs)
  

constants <- list(fee=range(programs_geolocated$fee_gbp, na.rm = TRUE),
                  ielts=range(programs_geolocated$ielts, na.rm=TRUE),
                  toefl=range(programs_geolocated$toefl, na.rm=TRUE),
                  study_levels=unique(programs_geolocated$study_level),
                  study_modes=c("On Campus", "Online", "Blended", "N/A"),
                  course_intensities=unique(programs_geolocated$course_intensity),
                  months=range(programs_geolocated$duration_length, na.rm=TRUE))

