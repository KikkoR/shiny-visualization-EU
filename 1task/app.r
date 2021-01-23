library(shiny)
library(geojsonio)
library(leaflet)
library(xlsx)

# Reading the sourcefile
file<-"../EIS2019_database.xlsx"
sheetIndex = 6
df<-read.xlsx(file, sheetIndex, header=TRUE)

# Selecting the data used for visualization
cont <- subset(df, select=c("NA.","X2.2.1.R.D.expenditure.in.the.business.sector"))
remove(df)
colnames(cont) <- c("country", "RD")
cont["RD"] <- round(cont["RD"], 1)

# Loading geojson of Europe
raw_eu <- rgdal::readOGR("Europe.geo.json", encoding = "UTF-8")

# Renaming countries
raw_eu$admin[raw_eu$admin == "Macedonia"] <- "North Macedonia"
cont$country[cont$country == "Czechia"] <- "Czech Republic"

# Matching data with geojson
eu <- raw_eu
cont <- head(cont[order(match(cont[,1],eu$admin)),], -5)
eu <- eu[eu$admin %in% cont$country,]
eu$rd <- cont[cont$country %in% eu$admin,]$RD

# Creating a countries that have no data
no_data_eu <- subset(raw_eu,admin %in% c('Bosnia and Herzegovina',
                                         'Albania','Andorra', 'Montenegro',
                                         'Republic of Serbia', 'Belarus',
                                         'Moldova', 'Kosovo'))
# Creating a sequential color map 
pal <- colorNumeric("Blues", eu$rd)
# Defining UI viewer app
ui <- fluidPage(
  titlePanel(title=h4("What’s the distribution of Research & Development score applied in business sector in the different areas of the Europe?", align="center")),
  leafletOutput("map",  width = "100%", height = "550px")
)


# Defining server that generates polygons for selected dataset
server <- function(input, output) {
  
  output$map <- renderLeaflet({
    # making labels for countries with data
    labels <- sprintf(
      "<strong>%s</strong><br/> R&D score: %g <br/>",
      eu$admin, 
      eu$rd
    ) %>% lapply(htmltools::HTML)
    
    # making labels for countries with no data
    not_prov_labels <- sprintf(
      "<strong>%s</strong><br/> R&D: No data provided <br/>",
      no_data_eu$admin
    ) %>% lapply(htmltools::HTML)
    
    leaflet() %>%
      
      # initiating a gray background
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      
      # adding countries which have no data
      addPolygons(data = no_data_eu, 
                  stroke = FALSE, 
                  smoothFactor = 0.3,
                  fillOpacity = 1,
                  fillColor = "#CECFCE",
                  label = not_prov_labels
      ) %>%
      # defining borders for countries which have no data
      addPolylines(data = no_data_eu,
                  color = "black",
                  stroke = TRUE,
                  opacity = 1, 
                  weight = 0.5) %>% 
      
      # adding countries which have data
      addPolygons(data = eu, 
                  stroke = FALSE, 
                  smoothFactor = 0.3,
                  fillOpacity = 1,
                  fillColor = ~pal(rd), 
                  label = labels,
                  #highlighting selected countries
                  highlight = highlightOptions(
                    weight = 3,
                    fillOpacity = 0.5,
                    fillColor = "#36BA51",
                    opacity = 1.0,
                    bringToFront = TRUE,
                    sendToBack = TRUE)
                  ) %>%
      
      # defining borders for countries which have data
      addPolylines( data = eu, 
                    color = "black",
                    stroke = TRUE,
                    opacity = 1, 
                    weight = 0.5) %>% 
      
      # creating a legend
      addLegend(data = eu, pal = pal, values = ~rd, opacity = 1.0, title = "R&D score")
})
  
}

# Create Shiny app ----
shinyApp(ui, server)