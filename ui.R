library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = ""
)


body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mapa", height = 500)
           ),
           box(width = NULL,
               dataTableOutput("programs_tbl")
           )
    ),
    column(width = 3,
           box(width = NULL, status = "warning",
               selectizeInput("subject",
                              "Subject",
                           choices = unique(programs_geolocated$subject), 
                           selected = unique(programs_geolocated$subject)[c(1, 12)],
                           multiple = TRUE)),
           box(width = NULL, status = "warning",
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