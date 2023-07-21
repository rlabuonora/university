library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = ""
)


body <- dashboardBody(
  fluidRow(
    column(width = 12,
           box(width = 4, solidHeader = TRUE,
               leafletOutput("mapa", height = 500)
           ),
           box(width = 8,
               dataTableOutput("programs_tbl", height = 500)
           )
    )),
  fluidRow(
    column(width = 12,
           box(width = 3, status = "warning",
               selectizeInput("subject",
                              "Subject",
                              choices = unique(programs_geolocated$subject), 
                              selected = unique(programs_geolocated$subject)[c(1, 12)],
                              multiple = TRUE)),
           box(width = 3, status = "warning",
               checkboxGroupInput("study_level", "Study Level",
                                  choices = unique(programs_geolocated$study_level),
                                  selected = unique(programs_geolocated$study_level)
               )
           )
           )
    
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)