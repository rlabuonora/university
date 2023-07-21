library(shinydashboard)
library(leaflet)
library(htmltools)
library(fresh)
library(DT)

function(input, output, session) {
  
  
  inBounds <- reactive({
    
    
    if (is.null(input$mapa_bounds))
      return(the_ranking_data[FALSE,])
    
    bounds <- input$mapa_bounds
    list(programs=filter_bounds(programs_geolocated, bounds),
         locations=filter_bounds(the_ranking_data, bounds))

  })
  
  output$programs_tbl <- renderDataTable({
    
    req(inBounds()$programs)
    datatable(inBounds()$programs %>% 
                select(program_title, study_level, study_mode, course_intensity,
                       duration, fee_gbp, university))
  })
  


  output$mapa <- renderLeaflet({
    
    leaflet(the_ranking_data) %>%
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers()
      # addCircleMarkers(color="goldenrod",
      #                  group="CAIF",
      #                  #layerId = ~ruee,
      #                  data=caif,
      #                  label = ~htmlEscape(nombre),
      #                  clusterOptions = markerClusterOptions()) %>%
      # addCircleMarkers(color="red",
      #                  group="ANEP",
      #                  #layerId = ~ruee,
      #                  data=escuelas,
      #                  label = ~htmlEscape(nombre),
      #                  clusterOptions = markerClusterOptions()) %>%
      # leaflet::addLegend(position = "bottomright",
      #                    values = ~inst, # data frame column for legend
      #                    opacity = .7, # alpha of the legend
      #                    pal = palPwr, # palette declared earlier
      #                    title = "") %>%
      # leaflet::addLayersControl(overlayGroups = c("CAIF", "ANEP"),
      #                           options = layersControlOptions(collapsed = FALSE)) %>%
  })
}
