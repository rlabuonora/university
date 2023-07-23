

function(input, output, session) {
  
  
  output$programs_tbl <- renderDataTable({
    
    programs <- programs() %>% 
      dplyr::select(program_title, subject, university, 
                    study_level, study_mode, course_intensity,
                    duration_length, fee_gbp) %>% 
      mutate(duration_length=if_else(
        is.na(duration_length), NA, paste0(duration_length, " Months")))
    
    datatable(programs,
              colnames=c("Program", "Subject", "University", "Level", "Mode", 
                         "Intensity", "Duration", "Yearly Fee"),
              rownames= FALSE) %>% 
      formatCurrency(
        "fee_gbp",
        currency = "£",
        interval = 3,
        mark = ",",
        digits = 0
      )
  })
  
  programs <- reactive({
    
    
    req(input$mapa_bounds)
    bounds <- input$mapa_bounds
    

    programs_geolocated %>% 
      filter_bounds(bounds) %>% 
      filter(study_mode %in% input$study_mode) %>% 
      filter(study_level %in% input$study_level) %>% 
      filter(subject %in% input$subject) %>% 
      filter(between(ielts, input$ielts[1], input$ielts[2])) %>% 
      filter(between(toefl, input$toefl[1], input$toefl[2])) %>% 
      filter(between(fee_gbp, input$fee[1], input$fee[2]))
      
      
  })
  

  output$mapa <- renderLeaflet({
    
    leaflet(locations_initial) %>%
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(label = ~htmlEscape(lbl), color="blue") %>% 
      setView(-3, 53,  zoom=6)

  })
  
  observe({
    
    data <- programs() %>% 
      group_by(location, university, longitude, latitude) %>% 
      summarize(n=n()) %>% 
      mutate(lbl=HTML(university, "</br>", n, " programs."))
    
    leafletProxy("mapa") %>% 
      clearMarkers() %>% 
      addCircleMarkers(data=data,
                       label = ~lbl)
  })
}
