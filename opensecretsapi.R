#Opensecrets
#API Link: https://www.opensecrets.org/api/
#Documentation: http://www.opensecrets.org/resources/create/api_doc.php

library(RJSONIO)
library(plyr)
library(RCurl)
library(rjson)

#set timeout option
options(timeout=600)

#set directory
setwd("~/opensecrets-API") #change to your working directory

#import ID list from downloaded from Opensecrets (http://www.opensecrets.org/resources/create/api_doc.php)
cidlist = read.csv("cidlist.csv")

#create sequence of CIDs
cid <-as.vector(cidlist$CID)

# Initialize a data frame
hdwd<- data.frame()

#enter API key
key <- '' #enter key here in strings

#enter FEC cycle
cycle <- '2012'

#base URL
base.url <- 'http://www.opensecrets.org/api/?method=candSummary&output=json&cycle='

# loop offset
for (i in 1:1150 ) {
  final.url <- paste(base.url,cycle,'&apikey=',key,'&cid=',cid[i],sep = "")
  data<- fromJSON(paste(readLines(final.url), collapse="")) 
  hdwd <- rbind(hdwd, ldply(data$response$summary, 
                                          function(x) c(x[[1]], x[[2]], x[[3]], x[[4]], x[[5]], x[[6]], x[[7]],x[[8]], x[[9]], x[[10]], 
                                                        x[[11]], x[[12]], x[[13]], x[[14]], x[[15]])))
}
colnames(hdwd) <- c('response', 'name', 'crp_id', 'cycle', 'state', 'party','chamber', 'first_elected','next_election','total','spent','cash_on_hand', 'debt', 'origin', 'source', 'last_updated')

# save to CSV
write.csv(hdwd, file='opensecrets_attributes.csv', row.names=FALSE)
