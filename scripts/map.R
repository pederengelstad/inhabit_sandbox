# This will NOT run with versions of Shiny > 1.2.0 and I don't know why.

shinyApp(ui = fillPage(tags$style(type = "text/css",
    ".half-fill { width: 50%; height: 100%; }",
    "#one { float: left; background-color: #ddddff; }",
    "#two { float: right; background-color: #ccffcc; }"
  ),
    leafletOutput("map", height="100%")
    ),
  
  server = function(input, output, session) {

  output$map = renderLeaflet({
    leaflet(options = leafletOptions(maxZoom = 10, preferCanvas = T)) %>% #Canvas helps draw vector graphics faster
      addProviderTiles(providers$CartoDB.DarkMatter, group = "Light", options = providerTileOptions(opacity = 0.8)) %>%
      fitBounds(lat1 = 48.808461, lng1 = -123.967893, lat2 = 24.848766, lng2 = -68.816526) %>%
      addPolygons(data = states, fill = 0, weight = 1.35, group = "states", color = 'white') %>%
      addLegend(position = "topright"
                , colors = c('#6e001c','#800026','#bd0026','#e31a1c'
                             ,'#fc4e2a','#fd8d3c','#feb24c'
                             ,'#fed976','#ffeda0','#fffFcc','','#505CA3','','#9DBFD6','','#A0ADB2'),
                labels = c("High","","","","","","","","", "Low",'','Zero Agreement','','Env. Dissimilar','','No Data'), 
                title = "Model Agreement", 
                opacity = 1.5,
                labFormat = ) %>%
      addLegend(position = "bottomright" 
            , colors = c('#00E30B','#1400F2','#fd00ff')
            , labels = c("Mgmt Area", "Known Distro","Occ Points"), 
            title = "Data Legend", opacity = 1) %>%
      addScaleBar(position = 'bottomleft', options = scaleBarOptions(maxWidth = 200))
    })
  
  observe({
    conus_tile_url = tilesURL
    if(!is.null(conus_tile_url)){
      leafletProxy("map") %>%
        clearGroup('conus') %>%
        addTiles(urlTemplate = tilesURL(), options = tileOptions(tms = T, opacity=0.8), group = 'conus', layerId = 'conus')
    } else {
      leafletProxy("map") %>%
        # Resets map back to default view upon deselection
        fitBounds(lat1 = 48.808461, lng1 = -123.967893, lat2 = 24.848766, lng2 = -68.816526)
  }})

  observe({

    m = mgmt_shp()

    # Display the selected managment polygon
    if(length(m)>0){

      bb = sp::bbox(m)

      leafletProxy("map") %>%
      clearGroup('mgmt') %>%
      addPolygons(fill = 0, data = mgmt_shp(), group = 'mgmt', weight = 2.5, opacity = 1, color = '#00E30B') %>%
      fitBounds(lat1 = bb[2], lng1 = bb[1], lat2 = bb[4], lng2 = bb[3])
    } else {
      leafletProxy("map") %>%
        clearGroup('mgmt') %>%
        fitBounds(lat1 = 48.808461, lng1 = -123.967893, lat2 = 24.848766, lng2 = -68.816526)
    }
  })

  # Toggle KDE on and off
  observe({

    d = distro_shp()

    if(!is.null(d)){
      leafletProxy("map") %>%
        clearGroup( 'distro') %>%
        addPolygons(data = distro_shp(), group = 'distro', color = "#1400F2", fill = 0, weight = 3, opacity = 1)
    } else {
      leafletProxy("map") %>%
        clearGroup('distro')
      }
  })

    # Toggle training points on and off
  observe({

    p = pres_pts()

    if(!is.null(p)){
      leafletProxy("map") %>%
        clearGroup( 'pres_pts') %>%
        # addMarkers(clusterOptions = markerClusterOptions())
        addCircleMarkers(data = pres_pts(), group = 'pres_pts', fillColor = "#fd00ff"
                         , radius = 4.5, fillOpacity = 1, color = '#000000', weight = 1
                         # ,clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = F,)
                         )
    } else {
        leafletProxy("map") %>%
          clearGroup('pres_pts')
      }
  })
})