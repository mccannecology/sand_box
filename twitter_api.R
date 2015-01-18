library(twitteR)

####################################################
#  Register OAuth credentials to twitter R session #
####################################################
# Code from twitteR package 

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"

consumerKey <- "XavkeOg9cRhwgNa6aZAy4Zuv1"
consumerSecret <- "2gKMqCB6yz1T64vI18BVE3xBGLT1a7fICnKobaHDLKpaoAlBhh"

twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=reqURL,
                             accessURL=accessURL,
                             authURL=authURL)

twitCred$handshake()
twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

registerTwitterOAuth(twitCred)

################## 
# Authenticating # 
##################
# http://thinktostart.com/twitter-authentification-with-r/

install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)

api_key <- "XavkeOg9cRhwgNa6aZAy4Zuv1"
api_secret <- "2gKMqCB6yz1T64vI18BVE3xBGLT1a7fICnKobaHDLKpaoAlBhh"
access_token <- "1621088430-K0d4E3X0qQZTLfXCBVpdz6yrM1pBPq8x8yy25r2"
access_token_secret <- "HlIb1IFYjhNBIPO1MfxQoiMtmwfP0zBCWggZAwfOkPAyg"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


########## 
# Search #
##########
searchTwitter("iphone")

