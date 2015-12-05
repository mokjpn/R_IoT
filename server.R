# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(curl)
library(jsonlite)
library(mongolite)
library(leaflet)
library(ggplot2)
library(tidyr)
library(httr)

source("config.R")
dbdata = data.frame()
# set "collection" to your own ownTracks' setting.
m <- mongo(collection="ownTracks", url=MONGO_URL)

shinyServer(function(input, output,session) {
  myReact <- reactiveValues(wdf=data.frame(), gdf=data.frame(), kdf=data.frame())
  checkMongo <- function() {
    locations <- m$find(query= '{}', sort='{"$natural":-1 }', limit= 30 )
    pts <- data.frame(lng=as.numeric(locations$lon), lat=as.numeric(locations$lat), time=as.character(as.POSIXct(as.numeric(locations$tst), origin="1970-01-01 00:00:00 GMT")))
    pts <- pts[complete.cases(pts),]
    return(pts)
  }
  checkWeather <- function() {
    con <- curl(WEATHER_HTTP_ENDPOINT)
    open(con)
    body <- readLines(con, warn=FALSE)
    print(body)
    close(con)
    return(data.frame(time=Sys.time(),fromJSON(body)))
  }
  checkKey <- function() {
    conk <- curl(HACKEY_HTTP_ENDPOINT)
    open(conk)
    bodyk <- readLines(conk, warn=FALSE)
    print(bodyk)
    close(conk)
    return(data.frame(time=Sys.time(),fromJSON(bodyk)))
  }
  gdata <- reactivePoll(3000, session, checkMongo, checkMongo) 
  wdata <- reactivePoll(1000, session, checkWeather, checkWeather)
  kdata <- reactivePoll(500, session, checkKey, checkKey)
  observe({ 
    myReact$gdf <- gdata()
    myReact$wdf <- rbind(isolate(myReact$wdf), wdata())
    myReact$kdf <- kdata()
  })
  output$myLED <- renderText({
    url <- PARTICLE_API_ENDPOINT
    r <- POST(url, body = list(access_token=PARTICLE_ACCESS_TOKEN, arg=input$led), encode = "form")
    print(r)
    input$led
  })
  
  output$dataTableG <- renderTable({ myReact$gdf })
  output$dataTableW <- renderTable({ myReact$wdf })
  output$myplot <- renderPlot({
    myReact$wdf %>% 
      gather('Var', 'Val', c(Pressure, Temperature, Humidity)) %>% 
      ggplot(aes(time,Val))+geom_line()+facet_grid(Var ~ ., scales="free_y")
  })
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng=myReact$gdf$lng, lat=myReact$gdf$lat, label=myReact$gdf$time)
  })
  output$myKey <- renderText(as.character(myReact$kdf$hackey.event))
})

