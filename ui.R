
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(leaflet)
shinyUI(
  navbarPage("RでIoTデモ",
             tabPanel("ownTracks",sidebarLayout(sidebarPanel(tableOutput(outputId="dataTableG")),mainPanel(leafletOutput("mymap")))),
             tabPanel("BME280", sidebarLayout(sidebarPanel(tableOutput(outputId="dataTableW")), mainPanel(plotOutput("myplot")))),
             tabPanel("KeyButton", h2("Current Key Status:", strong(textOutput(outputId="myKey"))), h2("Number of LED:", textOutput(outputId="myLED")),  sliderInput("led", "", min=1, max=12, value=1))
  )
)

