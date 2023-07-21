library(shinydashboard)
library(leaflet)
library(shinycssloaders)

header <- dashboardHeader(
  title = ""
)


body <- dashboardBody(
  use_theme(mytheme),
  fluidRow(
    column(width = 12,
           box(width = 4, solidHeader = TRUE,
               leafletOutput("mapa", height = 500)
           ),
           box(width = 8,
               status = "warning",
               withSpinner(
                dataTableOutput("programs_tbl")
               )
           )
    )),
  fluidRow(
    column(width = 12,
           box(width = 4, status = "warning",
               selectizeInput("subject",
                              "Subject",
                              choices = unique(programs_geolocated$subject), 
                              selected = unique(programs_geolocated$subject)[c(1, 9)],
                              multiple = TRUE)),
           box(width=4, status="warning",
               h4("Requirements"),
               sliderInput("ielts", "IELTS",
                           min = 0, 
                           max = 9, 
                           value = c(0, 9)),
               sliderInput("toefl", "TOEFL",
                           min = 0, 
                           max = 120, 
                           value = c(0, 120))),
           box(width = 2, status = "warning",
               checkboxGroupInput("study_level", "Study Level",
                                  choices = unique(programs_geolocated$study_level),
                                  selected = unique(programs_geolocated$study_level)
               )),
           box(width=2, status="warning",
               checkboxGroupInput("study_mode", "Study Mode",
                                  choices = unique(programs_geolocated$study_mode),
                                  selected = unique(programs_geolocated$study_mode))),
           box(width=4, status="warning",
               sliderInput("fee", "Tution fee (£/year):",
                           min = constants$fee[1], 
                           max = constants$fee[2], 
                           value = round(c(constants$fee[1],
                                     constants$fee[2]))))
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)