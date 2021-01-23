# shiny-visualization-EU
The overall goal of this project is to correctly visualize some deep level questions over a set of data. The method for visualization it's over the R package Shiny. 
We decided to provide the answers, through the use of a 2019 open dataset called the [European innovation scoreboard](https://data.europa.eu/euodp/en/data/dataset/european-innovation-scoreboard-2019), which provides a comparative analysis of innovation performance in EU countries, other European countries, and regional neighbours. Thought the tables, it is possible to observe all the relative strengths and weaknesses of national innovation systems. Therefore, is a tool to help countries identify areas they need to address. 

# How to execute
The implementations are loaded to [shinyapps.io](https://www.shinyapps.io/) and could be accessed via: 
- Question 1: [link 1](https://ostapkharysh.apps.io/MapVisualization)
- Question 2: [link 2](https://federicorodigari.apps.io/2task/)
- Question 3: [link 3](https://lorenzoframba.apps.io/Eu_Innovation_Parameters/)

For question 2, make sure to use Chrome in order to visualize the mouseover function that displays the name of the nations, because for some reasons, Safari doesn't seem to support Shiny at its fullest capabilities.

If you want to run the code manually, you could download  and run them as the ordinary shiny apps. In this case the installation of ["ggtips"](https://github.com/Roche/ggtips) is required.
To install ggtips, use devtools:
```
devtools::install\_github("Roche/ggtips")
```
