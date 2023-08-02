library(shinydashboard)
library(leaflet)
library(shinycssloaders)
#library(shinydashboardPlus)

header <- dashboardHeader(
  title = ""
)


body <- dashboardBody(
  use_theme(mytheme),
  tags$head(tags$style('#mapa-div .box-header{ display: none}')),
  fluidRow(
    column(width = 4,
           
           box(width = NULL, id="mapa-div", solidHeader = TRUE,
               leafletOutput("mapa", height = 600))),
    column(
      width=8,
      box(width = NULL, 
          headerBorder=FALSE,
          collapsible=TRUE,
          collapsed = TRUE,
          title="Filter Programs",
          status = "warning",
          fluidRow(
            column(width=4,
                   selectizeInput("subject",
                                  "Subject",
                                  choices = unique(programs_geolocated$subject), 
                                  selected = unique(programs_geolocated$subject)[c(1, 9)],
                                  multiple = TRUE),
                  hr(),
            
                   sliderInput("fee", "Tuition fee (£/year):",
                               min = constants$fee[1], 
                               max = constants$fee[2], 
                               value = round(c(constants$fee[1],
                                               constants$fee[2]))),
            hr(),
                   sliderInput("duration", "Duration (months):",
                               min=0,
                               max=36,
                               value=c(0, 36))),
            column(width=6,
                   offset=1,
                   h4("Requirements"),
                          sliderInput("ielts", "IELTS",
                                      min = 0, 
                                      max = 9, 
                                      value = c(0, 9)),
                          sliderInput("toefl", "TOEFL",
                                      min = 0, 
                                      max = 120, 
                                      value = c(0, 120)),
                   hr(),
                          column(width=4,
                                 checkboxGroupInput("study_level", "Study Level",
                                                    choices = constants$study_levels,
                                                    selected = constants$study_levels)),
                          column(width=4,
                                 checkboxGroupInput("study_mode", "Study Mode",
                                                    choices = constants$study_modes,
                                                    selected = constants$study_modes)),
                          column(width=4,
                                 checkboxGroupInput("course_intensity", "Course Intensity",
                                                    choices = constants$course_intensities,
                                                    selected = constants$course_intensities)))

                 
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
            dataTableOutput("programs_tbl"))),
      box(width = NULL,
          title="Universities",
          collapsible=TRUE,
          status = "warning",
          headerBorder=FALSE,
          withSpinner(
            dataTableOutput("universities_tbl"))))))



dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)