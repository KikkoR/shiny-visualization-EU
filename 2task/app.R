#versione che funzionicchia brutte troie

library(shiny)
library(tidyverse)
library(xlsx)
library(plotly)
file<-"EIS2019_database.xlsx"
sheetIndex<-6 
df<-read.xlsx(file, sheetIndex, header=TRUE)
df$NA..1 <- as.factor(df$NA..1) 
df = df[-1,]
df$location<-factor(c("w","e","e","n","w","n","w","s","s","w","e","s","s","n","n","w","e","s","w","w","e","s","e","e","e","n","n","w","n","e","e","n","e","w","s","e"))

ContVars <- c( "NA.","NA..1",                                                    
               "X1.1.1.New.doctorate.graduates","X1.1.2.Population.completed.tertiary.education",           
               "X1.1.3.Lifelong.learning","X1.2.1.International.scientific.co.publications",          
               "X1.2.2.Scientific.publications.among.top.10..most.cited","X1.2.3.Foreign.doctorate.students",                        
               "X1.3.1.Broadband.penetration","X1.3.2.Opportunity.driven.entrepreneurship",               
               "X2.1.1.R.D.expenditure.in.the.public.sector","X2.1.2.Venture.capital.investments",                       
               "X2.2.1.R.D.expenditure.in.the.business.sector","X2.2.2.Non.R.D.innovation.expenditure",                    
               "X2.2.3.Enterprises.providing.ICT.training","X3.1.1.SMEs.with.product.or.process.innovations",          
               "X3.1.2.SMEs.with.marketing.or.organisational.innovations","X3.1.3.SMEs.innovating.in.house",                          
               "X3.2.1.Innovative.SMEs.collaborating.with.others","X3.2.2.Public.private.co.publications",                    
               "X3.2.3.Private.co.funding.of.public.R.D.expenditures","X3.3.1.PCT.patent.applications",                           
               "X3.3.2.Trademark.applications","X3.3.3.Design.applications",                               
               "X4.1.1.Employment.in.knowledge.intensive.activities","X4.1.2.Employment.fast.growing.firms.innovative.sectors",  
               "X4.2.1.Medium...high.tech.product.exports","X4.2.2.Knowledge.intensive.services.exports",              
               "X4.2.3.Sales.of.new.to.market.and.new.to.firm.innovations","Summary.Innovation.Index")  

doctorate<-"X1.1.1.New.doctorate.graduates"
# User Interface
ui <- basicPage(
  headerPanel("Correlations with doctorate students"),
  
  sidebarPanel ( 
    
    
    # p("Results of a chemical analysis of wines
    #   grown in the same region in Italy but from
    #   three different cultivars."),
    # 
    # p("Data from the ",
    #   a(href = "https://archive.ics.uci.edu/ml/datasets/Wine", "UCI Machine Learning Repository.")),
    
    selectInput('x','x-merda',doctorate),
    selectInput('y','y-axis',ContVars, selected = "X1.1.1.New.doctorate.graduates")
    
  ),
  mainPanel(plotlyOutput(outputId = "myplot"))
  
  
  
)

# Server
server <- function(input, output) {
  
  output$myplot <- renderPlotly({
    ggplotly(
      ggplot(df,aes(x=get(input$y),
                      y=X1.1.1.New.doctorate.graduates,
                      size= Summary.Innovation.Index, color=location, name=NA.)) +
      geom_point(alpha=0.8,stroke = 2) +
      scale_size(range = c(0.01, 10), name="Innovation index")+
      scale_color_manual(values = c("s" = "#984ea3", "n" = "#377eb8", "w"="#4daf4a","e"="#e41a1c")),
      tooltip = "name"
    )
  })  
  
}

shinyApp(ui, server)