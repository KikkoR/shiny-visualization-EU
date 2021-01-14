library(shiny)
library(geojsonio)
library(leaflet)


setClass("num.with.commas")
setAs("character", "num.with.commas", 
      function(from) as.numeric(gsub(",", ".", from) ) )

cont <- read.csv(file = 'task1data.csv', sep=";", 
                 colClasses=c('character', 'num.with.commas'))
colnames(cont) <- c("country", "RD")


eu <- rgdal::readOGR("custom.geo.json", encoding = "UTF-8")

eu$admin[eu$admin == "Macedonia"] <- "North Macedonia"
cont$country[cont$country == "Czechia"] <- "Czech Republic"
cont = head(cont[order(match(cont[,1],eu$admin)),], -5)


length(eu)
eu <- eu[eu$admin %in% cont$country,]
length(eu)
RD <- cont[cont$country %in% eu$admin,]$RD
eu$rd <- RD


pal <- colorNumeric("Blues", eu$rd)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  titlePanel(title=h4("What’s the distribution of Research & Development applied in business sector in the different areas of the EU", align="center")),
  leafletOutput("map",  width = "100%", height = "500px")
  
)





# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    leaflet(eu) %>%
      addTiles() %>%
      addPolygons(stroke = FALSE, 
                  smoothFactor = 0.3, fillOpacity = 1, fillColor = ~pal(RD), 
                  label = ~paste0(admin, ": ", formatC(RD, big.mark = ","))) %>%
      addLegend(pal = pal, values = ~RD, opacity = 1.0)
})
  
}

# Create Shiny app ----
shinyApp(ui, server)
#app <- shinyApp(ui = ui, server = server)
#runApp(app, launch.browser = TRUE)