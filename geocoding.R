# after registration, every user will have their own key
google_key = "Your key"
bing_Key = "Your key"

#geocoding 
library(tidyverse)
library(dplyr)
library(tidyr)

#Google Map
register_google(key = google_key)

#geocode biowpPulled_April with google map
biowpPulled_April_uniLoc_geo_google1<- biowpPulled_April_uniLoc1%>%
  mutate_geocode(location4)%>%
  rename(lat_google = lat,
         lon_google = lon)

save_as_csv(biowpPulled_April_uniLoc_geo_google1, "biowpPulled_April_uniLoc_geo_google1.csv")

biowpPulled_April_uniLoc_geo_google2<- biowpPulled_April_uniLoc2%>%
  mutate_geocode(location4)%>%
  rename(lat_google = lat,
         lon_google = lon)

biowpPulled_April_uniLoc_geo_google <- rbind(biowpPulled_April_uniLoc_geo_google1,
                                             biowpPulled_April_uniLoc_geo_google2)

save_as_csv(biowpPulled_April_uniLoc_geo_google, "biowpPulled_April_uniLoc_geo_google.csv")

#bing map
##creating geocode_bing1 function, which can only input one address character
geocode_bing1 <- function(str){
  require(RCurl)
  require(RJSONIO)
  u <- URLencode(paste0("http://dev.virtualearth.net/REST/v1/Locations?q=", str, "&maxResults=1&key=", BingMapsKey))
  d <- getURL(u)
  j <- fromJSON(d,simplify = FALSE) 
  if (j$resourceSets[[1]]$estimatedTotal > 0) {
    lat <- j$resourceSets[[1]]$resources[[1]]$point$coordinates[[1]]
    lon <- j$resourceSets[[1]]$resources[[1]]$point$coordinates[[2]]
  }
  else {    
    lat <- lon <- NA
  }
  data.frame(lat,lon)
} 

##creating geocode_bing2 function whose input shoule be a vector, based on geocode_bing2()
geocode_bing2 <- function(vct){
  lats <- c()
  lons <- c()
  for (i in 1:length(vct)){
    address = vct[i]
    lat <- (geocode_bing1(address))$lat
    lon <- (geocode_bing1(address))$lon
    lats[i] = lat
    lons[i] = lon
  }
  data.frame(lats,lons)
}

##geocode biowpPulled_April with bing map
BingMapsKey = bing_key1
biowpPulled_April_uniLoc_geo_bing1<- biowpPulled_April_uniLoc1%>%
  mutate(lat_bing = (geocode_bing2(location4))$lats,
         lon_bing = (geocode_bing2(location4))$lon)
save_as_csv(biowpPulled_April_uniLoc_geo_bing1, "biowpPulled_April_uniLoc_geo_bing1.csv")

BingMapsKey = bing_key2
biowpPulled_April_uniLoc_geo_bing2<- biowpPulled_April_uniLoc2%>%
  mutate(lat_bing = (geocode_bing2(location4))$lats,
         lon_bing = (geocode_bing2(location4))$lon)
save_as_csv(biowpPulled_April_uniLoc_geo_bing2, "biowpPulled_April_uniLoc_geo_bing2.csv")
biowpPulled_April_uniLoc_geo_bing <- rbind(biowpPulled_April_uniLoc_geo_bing1,
                                           biowpPulled_April_uniLoc_geo_bing2)
save_as_csv(biowpPulled_April_uniLoc_geo_bing, "biowpPulled_April_uniLoc_geo_bing.csv")

#OpenStreetMap
##creating geocode_OSM2 function because geocode_OSM() can't return NA values if no results for the query
geocode_OSM2 <- function(vct){
  require(tmaptools)
  lats <- c()
  lons <- c()
  
  for (i in 1:length(vct)){
    address = vct[i]
    if(is.null(geocode_OSM(address))){
      lat <- NA
      lon <- NA
    }
    else{
      lat <- (geocode_OSM(address,as.data.frame = TRUE))$lat
      lon <- (geocode_OSM(address,as.data.frame = TRUE))$lon
    }
    lats[i] = lat
    lons[i] = lon
  }
  data.frame(lats,lons)
}

### geocode biowpPulled_April with OpenStreetMap
biowpDT0410_geo_OSM <- biowpDT0410_geo_bing%>%
  mutate(lat_OSM = (geocode_OSM2(location))$lats,
         lon_OSM = (geocode_OSM2(location))$lons)

save_as_csv(biowpDT0410_geo_OSM, "biowpPulled_April_uniLoc_geo.csv")