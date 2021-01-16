library(shiny)
library(geojsonio)
library(leaflet)


setClass("num.with.commas")
setAs("character", "num.with.commas", 
      function(from) as.numeric(gsub(",", ".", from) ) )

cont <- read.csv(file = 'task1data.csv', sep=";", 
                 colClasses=c('character', 'num.with.commas'))
colnames(cont) <- c("country", "RD")


raw_eu <- rgdal::readOGR("Europe.geo.json", encoding = "UTF-8")

raw_eu$admin[raw_eu$admin == "Macedonia"] <- "North Macedonia"
cont$country[cont$country == "Czechia"] <- "Czech Republic"


eu <- raw_eu
cont <- head(cont[order(match(cont[,1],eu$admin)),], -5)
eu <- eu[eu$admin %in% cont$country,]
eu$rd <- cont[cont$country %in% eu$admin,]$RD

no_data_eu <- subset(raw_eu,admin %in% c('Bosnia and Herzegovina','Albania','Andorra', 'Montenegro', 'Republic of Serbia', 'Belarus', 'Moldova', 'Kosovo'))


pal <- colorNumeric("Blues", eu$rd)
# Define UI for dataset viewer app ----
ui <- fluidPage(
  titlePanel(title=h4("What’s the distribution of Research & Development score applied in business sector in the different areas of the Europe?", align="center")),
  leafletOutput("map",  width = "100%", height = "550px")
)



# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    labels <- sprintf(
      "<strong>%s</strong><br/> R&D:%g <br/>",
      eu$admin, 
      eu$rd
    ) %>% lapply(htmltools::HTML)
    
    
    not_prov_labels <- sprintf(
      "<strong>%s</strong><br/> R&D: No data provided <br/>",
      no_data_eu$admin
    ) %>% lapply(htmltools::HTML)
    
    leaflet(eu) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      addPolygons(data = no_data_eu, 
                  stroke = FALSE, 
                  smoothFactor = 0.3,
                  fillOpacity = 1,
                  fillColor = "#CECFCE",
                  label = not_prov_labels
      ) %>%
      
      addPolylines(data = no_data_eu,
                  color = "black",
                  stroke = TRUE,
                  opacity = 1, 
                  weight = 0.5) %>% 
      
      addPolygons(stroke = FALSE, 
                  smoothFactor = 0.3,
                  fillOpacity = 1,
                  fillColor = ~pal(rd), 
                  label = labels, #~paste0(admin, ": ", formatC(RD, big.mark = ","))
                  highlight = highlightOptions(
                    weight = 3,
                    fillOpacity = 0.5,
                    fillColor = "#36BA51",
                    opacity = 1.0,
                    bringToFront = TRUE,
                    sendToBack = TRUE)
                  ) %>%
      
      # Add border
      addPolylines(color = "black",
                   stroke = TRUE,
                   opacity = 1, 
                   weight = 0.5) %>% 
      
      addLegend(pal = pal, values = ~rd, opacity = 1.0, title = "R&D score")
})
  
}

# Create Shiny app ----
shinyApp(ui, server)