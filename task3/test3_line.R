#install.packages("xlsx")
#install.packages("dplyr") 
library(shiny)
library(rgdal)
library(ggmap)
library(ggplot2)
library(rgeos)
library(broom)
library(plyr)
library(GGally)
library(dplyr)
library(xlsx)
library("reshape2")


message("reading and loading of the dataset,\n this operation can take sometimes the datasets are very big.")

if(!exists("accidents")){
  message("wrangling data...")
  
  
  
  
  
  file<-"EIS2019_databasev2.xlsx"
  sheetIndex<-3 
  df<-read.xlsx(file, sheetIndex, header=TRUE)
  
  a = na.omit(data.frame(df$NA., df$Innovators, df$Innovators.1,df$Innovators.2, df$Innovators.3,df$Innovators.4,df$Innovators.5,df$Innovators.6, df$Innovators.7))#[-1,]
  
  a2011 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.7, df$Human.resources.7, df$Research.systems.7, df$Innovation.friendly.environment.7, df$Finance.and.support.7, df$Firm.investments.7, df$Innovators.7, df$Linkages.7, df$Intellectual.assets.7, df$Employment.impacts.7, df$Sales.impacts.7))
  a2011$year=2011
  names(a2011) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2012 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.6, df$Human.resources.6, df$Research.systems.6, df$Innovation.friendly.environment.6, df$Finance.and.support.6, df$Firm.investments.6, df$Innovators.6, df$Linkages.6, df$Intellectual.assets.6, df$Employment.impacts.6, df$Sales.impacts.6))
  a2012$year=2012
  names(a2012) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2013 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.5, df$Human.resources.5, df$Research.systems.5, df$Innovation.friendly.environment.5, df$Finance.and.support.5, df$Firm.investments.5, df$Innovators.5, df$Linkages.5, df$Intellectual.assets.5, df$Employment.impacts.5, df$Sales.impacts.5))
  a2013$year=2013
  names(a2013) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2014 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.4, df$Human.resources.4, df$Research.systems.4, df$Innovation.friendly.environment.4, df$Finance.and.support.4, df$Firm.investments.4, df$Innovators.4, df$Linkages.4, df$Intellectual.assets.4, df$Employment.impacts.4, df$Sales.impacts.4))
  a2014$year=2014
  names(a2014) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2015 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.3, df$Human.resources.3, df$Research.systems.3, df$Innovation.friendly.environment.3, df$Finance.and.support.3, df$Firm.investments.3, df$Innovators.3, df$Linkages.3, df$Intellectual.assets.3, df$Employment.impacts.3, df$Sales.impacts.3))
  a2015$year=2015
  names(a2015) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2016 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.2, df$Human.resources.2, df$Research.systems.2, df$Innovation.friendly.environment.2, df$Finance.and.support.2, df$Firm.investments.2, df$Innovators.2, df$Linkages.2, df$Intellectual.assets.2, df$Employment.impacts.2, df$Sales.impacts.2))
  a2016$year=2016
  names(a2016) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2017 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index.1, df$Human.resources.1, df$Research.systems.1, df$Innovation.friendly.environment.1, df$Finance.and.support.1, df$Firm.investments.1, df$Innovators.1, df$Linkages.1, df$Intellectual.assets.1, df$Employment.impacts.1, df$Sales.impacts.1))
  a2017$year=2017
  names(a2017) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  a2018 =  na.omit(data.frame(df$NA., df$Summary.Innovation.Index, df$Human.resources, df$Research.systems, df$Innovation.friendly.environment, df$Finance.and.support, df$Firm.investments, df$Innovators, df$Linkages, df$Intellectual.assets, df$Employment.impacts, df$Sales.impacts))
  a2018$year=2018
  names(a2018) <- c("Country","Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments", "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact" , "Year")
  
  ciao = dplyr::bind_rows(a2011,a2012,a2013,a2014,a2015,a2016,a2017,a2018)
  
}

server <- function(input,output,session){
  
  plotOutput("plot")
  
  datas<-reactive({
    #req <-(input$id)
    
    
    ciao %>% filter(ciao$Country %in% input$id)  %>%  mutate(selected_score = input$sel_metric)  
  })
  
  observe({
    updateSelectInput(session, "sel_country",choices = a$df.NA.)
    updateSelectInput(session, "id",choices = a$df.NA.)
    #updateSelectInput(session, 'sel_metric', choices = NULL)
  })
  
  observe({
    data <- datas()
    updateSelectInput(session, 'sel_metric', choices = NULL)
  }) 
  
  
  #gets the x variable name, will be used to change the plot legends
  yVarName <- reactive({
    input$sel_country
  }) 
  
  output$summary <- renderPrint({
    summary(datas())
  })
  
  output$plot <- renderPlot({
    

    newData = datas()
  
    req(between(length(input$id), 1,100))
    
    g <- ggplot(data = newData, aes(y = newData[[as.name(selected_score)]], x=factor(Year) , label = round(newData[[as.name(selected_score)]]) , group=Country, color=Country )) 
    g + geom_line() + geom_point() + theme_bw() + geom_text(size = 3, position=position_dodge(width=0.9), vjust=-0.25) + labs(x ="Year", y = input$sel_metric) #+ geom_smooth(method="lm") 
      
    
  })

}

ui <-basicPage(
  
  titlePanel(title=h4("How does an innovation metric change over time, given a chosen location?", align="center")),
  sidebarPanel(

    selectizeInput("id", "Select the Location", multiple = T, "Names", choices = "", options = list(maxItems = 12),  selected = 'Italy'),

    radioButtons("sel_metric", "Select the Metric",
                 c("Innovation Index", "Human Resources", "Research System", "Friendly Environment", "Finance", "Firm Investments",
                   "Innovators", "Linkages", "Intellectual Assets", "Employment Impact", "Sales Impact")),

    
  ),
  mainPanel(plotOutput("plot"))
)


shinyApp(server = server, ui = ui)