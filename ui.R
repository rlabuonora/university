library(shinydashboard)
library(leaflet)
library(shinycssloaders)
#library(shinydashboardPlus)

header <- dashboardHeader(
  title = ""
)


body <- dashboardBody(
  use_theme(mytheme),
  tags$head(tags$style('#mapa .box-header{ display: none}')),
  fluidRow(
    column(width = 4,
           
           box(width = NULL, id="mapa", solidHeader = TRUE,
               leafletOutput("mapa", height = 500))),
    column(
      width=8,
      box(width = NULL, 
          headerBorder=FALSE,
          collapsible=TRUE,
          collapsed = TRUE,
          title="Filter Programs",
          status = "warning",
          fluidRow(
            column(width=6,
                   selectizeInput("subject",
                                  "Subject",
                                  choices = unique(programs_geolocated$subject), 
                                  selected = unique(programs_geolocated$subject)[c(1, 9)],
                                  multiple = TRUE)),
            column(width=3,
                   checkboxGroupInput("study_level", "Study Level",
                                      choices = unique(programs_geolocated$study_level),
                                      selected = unique(programs_geolocated$study_level))),
            column(width=3,
                   checkboxGroupInput("study_mode", "Study Mode",
                                      choices = unique(programs_geolocated$study_mode),
                                      selected = unique(programs_geolocated$study_mode)))),
          column(width=12,
                 hr(),
                 sliderInput("ielts", "IELTS",
                             min = 0, 
                             max = 9, 
                             value = c(0, 9)),
                 sliderInput("toefl", "TOEFL",
                             min = 0, 
                             max = 120, 
                             value = c(0, 120)),
                 hr(),
                 sliderInput("fee", "Tution fee (£/year):",
                             min = constants$fee[1], 
                             max = constants$fee[2], 
                             value = round(c(constants$fee[1],
                                             constants$fee[2])))
                 # ,sliderInput("duration", "Months",
                 #             min=constants$months[1],
                 #             max=constants$months[2],
                 #             value=c(0, constants$months[2]))
          )),
      box(width = NULL,
          title="Programs",
          collapsible=TRUE,
          status = "warning",
          headerBorder=FALSE,
          withSpinner(
            dataTableOutput("programs_tbl"))))))



dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)