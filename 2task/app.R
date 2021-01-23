#devtools::install_github("Roche/ggtips")

library(shiny)
library(tidyverse)
library(xlsx)
library(plotly)
library(ggtips)
file<-"EIS2019_database.xlsx"
sheetIndex<-6 
df<-read.xlsx(file, sheetIndex, header=TRUE)
df$NA..1 <- as.factor(df$NA..1) 
df = df[-1,]
df$Region<-factor(c("Western"," Eastern"," Eastern"," Northern","Western"," Northern","Western"," Southern"," Southern","Western"," Eastern"," Southern"," Southern"," Northern"," Northern","Western"," Eastern"," Southern","Western","Western"," Eastern"," Southern"," Eastern"," Eastern"," Eastern"," Northern"," Northern","Western"," Northern"," Eastern"," Eastern"," Northern"," Eastern","Western"," Southern"," Eastern"))
df[ df == ":" ] <- NA
df=na.omit(df)
cols <- names(df)[3:30]
df[cols] <- lapply(df[cols], as.numeric)
names(df)[1] <- "nation"


ContVars <- c( "International scientific publications"="X1.2.1.International.scientific.co.publications",          
               "Scientific publications among top 10 most cited"="X1.2.2.Scientific.publications.among.top.10..most.cited",
               "Broadband penetration"="X1.3.1.Broadband.penetration", #not relevant
               "Opportunity driven entrepreneurship"="X1.3.2.Opportunity.driven.entrepreneurship",#not relevant               
               "R&D expenditure in the public sector"="X2.1.1.R.D.expenditure.in.the.public.sector",
               "R&D expenditure in the business sector"="X2.2.1.R.D.expenditure.in.the.business.sector",
               "Venture capital investment"="X2.1.2.Venture.capital.investments",#not relevant                       
               "Non R&D innovation expenditure"="X2.2.2.Non.R.D.innovation.expenditure",#not relevant                    
               "Entreprises providing ICT training"="X2.2.3.Enterprises.providing.ICT.training",#not so relevant
               "SMEs with product/process innovations"="X3.1.1.SMEs.with.product.or.process.innovations",          
               "SMEs with marketing/organisational innovations"="X3.1.2.SMEs.with.marketing.or.organisational.innovations",
               "SMEs innovating in house"="X3.1.3.SMEs.innovating.in.house",#not relevant                        
               "SMEs collaborating with others"="X3.2.1.Innovative.SMEs.collaborating.with.others",#not so relevant
               "Public and private pubblications"="X3.2.2.Public.private.co.publications",                    
               "Private co-funding of public R&D expenditures"="X3.2.3.Private.co.funding.of.public.R.D.expenditures",#not relevant
               "PCT patent applications"="X3.3.1.PCT.patent.applications", #not relevant                          
               "Trademark applications"="X3.3.2.Trademark.applications",
               "Design applications"="X3.3.3.Design.applications", #not relevant                              
               "Employment in knowledge intensive activities"="X4.1.1.Employment.in.knowledge.intensive.activities",
               "Employment fast growing firms innovative sectors"="X4.1.2.Employment.fast.growing.firms.innovative.sectors",#not relevant  
               "Medium & high tech product exports"="X4.2.1.Medium...high.tech.product.exports",#not relevant
               "Knowledge intensive services exports"="X4.2.2.Knowledge.intensive.services.exports",              
               "Sales of new to market and new to firm innovations"="X4.2.3.Sales.of.new.to.market.and.new.to.firm.innovations",
               "Summary Innovation Index"="Summary.Innovation.Index")  


# User Interface
ui <- fluidPage(
  
  headerPanel(h4("How do the different innovation performance metrics correlate with the number of new doctorate students in the different regions?")),
  
  sidebarLayout(
    sidebarPanel(selectInput('y','Select the metric',ContVars, selected = "X1.1.1.New.doctorate.graduates"),
                radioButtons("lm", "Trend",c("Show", "Hide"),selected = "Show"),
                checkboxGroupInput("region", "Regions", c("all"," Eastern", "Western"," Northern"," Southern"),selected = "all")
                ),
  mainPanel(uiOutput(outputId = "myplot"))
  )
)

# Server
server <- function(input, output) {
 
  dat <- reactive({
    validate(
      need(input$region != "", 'Please choose at least one feature in the "Region" checkbox to display the graph')
    )
    mydf <- df
    if(input$region != "all")
      mydf <- subset(mydf,Region %in% input$region)
    mydf
  })
   
  output$myplot <- renderWithTooltips(
    
    if(input$lm == "Hide"){p<-ggplot(dat(),aes(x=X1.1.1.New.doctorate.graduates,y=get(input$y)))+
      geom_point(alpha=0.8,aes(size= Summary.Innovation.Index, color=Region,name=nation)) +
      labs(x = "New doctorate graduates",y = names(ContVars[which(ContVars == input$y)]))+
      scale_size(range = c(0.01, 13), name="Innovation Index",breaks = c(0.175,0.35,0.525,0.7))+
      scale_color_manual(values=c("#984ea3","#377eb8","#4daf4a","#e41a1c"))+
      guides(color = guide_legend(override.aes = list(size = 2)))
    }
    else{p<-ggplot(dat(),aes(x=X1.1.1.New.doctorate.graduates,y=get(input$y)))+
     geom_point(alpha=0.8,aes(size= Summary.Innovation.Index,color=Region,name=nation)) +
     labs(x = "New doctorate graduates",y = names(ContVars[which(ContVars == input$y)]))+
     scale_size(range = c(0.01, 13), name="Innovation Index",breaks = c(0.175,0.35,0.525,0.7))+
     scale_color_manual(values=c("#984ea3","#377eb8","#4daf4a","#e41a1c"))+
     guides(color = guide_legend(override.aes = list(size = 2)))+geom_smooth()
    },

    varDict = list(nation = "Nation"),

    width=7,
    height=4
  )  
}

shinyApp(ui, server)