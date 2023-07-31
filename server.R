

function(input, output, session) {
  
  
  output$programs_tbl <- renderDataTable({
    

    
    progs_tbl <- programs_filtered() %>% 
      dplyr::select(program_title, subject, university, 
                    study_level, study_mode, course_intensity,
                    duration_length, fee_gbp) %>% 
      mutate(duration_length=if_else(
        is.na(duration_length), NA, paste0(duration_length, " Months")))
    
    datatable(progs_tbl,
              options = list(pageLength = 5),
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
  
  output$universities_tbl <- renderDataTable({
    
    df <- locations() %>% 
      arrange(rank_sort) %>% 
      select(-rank_sort, -location, -longitude, -latitude) %>% 
      distinct()
    
    print(colnames(df))
    
    datatable(df,
              colnames=c("University", "Rank", "Overall Score", "Teaching", "Research",
                         "Citations", "Industry Income", "International Outlook"),
              rownames= FALSE)
  })
  

  
  programs_filtered <- reactive({
    

    req(input$mapa_bounds)
    bounds <- input$mapa_bounds

    programs_geolocated %>% 
      filter_bounds(bounds) %>% 
      filter(study_mode %in% input$study_mode) %>% 
      filter(study_level %in% input$study_level) %>% 
      filter(subject %in% input$subject) %>% 
      filter(between(ielts, input$ielts[1], input$ielts[2])) %>% 
      filter(between(toefl, input$toefl[1], input$toefl[2])) %>% 
      filter(between(fee_gbp, input$fee[1], input$fee[2])) %>% 
      arrange(university)
      
      
  })
  
  
  locations <- reactive({


    programs_filtered() %>%
      group_by(university, location, longitude, latitude) %>% 
      summarize() %>% 
      left_join(universities, by=c("university", "location")) %>% 
      dplyr::select(university, rank, location, longitude, latitude,
                    rank_sort, overall_score, 
                    teaching, research, citations,
                    industry_income, international_outlook) %>% 
      ungroup()
  })

  output$mapa <- renderLeaflet({
    

    leaflet(locations_initial) %>%
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(label = ~university, color="blue") %>% 
      #setView(lat = -32.8, lng = -56, zoom = 7)
      setView(-3, 53,  zoom=6)

  })
  
  observe({
    
    
    df <- locations()

    if(nrow(locations())>0) { 
      leafletProxy("mapa", session,data=df) %>% 
        clearMarkers() %>% 
        addCircleMarkers(label = ~university, color="blue")
    }
    
  })
}
