
library(shiny)
library(ggplot2)

# df <-   readRDS(file = "data/wine.rds")
# df$Cultivar <- as.factor(df$Cultivar) 
file<-"EIS2019_database.xlsx"
sheetIndex<-6 
df<-read.xlsx(file, sheetIndex, header=TRUE)
colnames(df)
df$NA..1 <- as.factor(df$NA..1) 

shinyServer(function(input, output) {
  
  output$plot <- renderPlot(ggplot(df, aes(
    x = get(input$x),
    y = get(input$y), 
    colour = NA..1)) + 
      geom_point(size = 3) + 
      xlab(input$x) +
      ylab(input$y) +
      theme(axis.title=element_text(size=14)) + 
      theme(legend.title=element_text(size=14))+ 
      theme(legend.text=element_text(size=14))
    #theme(aspect.ratio=1)
  )
})