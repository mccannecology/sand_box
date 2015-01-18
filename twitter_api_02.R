# http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/

#install the necessary packages
install.packages("ROAuth")
install.packages("twitteR")
install.packages("wordcloud")
install.packages("tm")

library("ROAuth")
library("twitteR")
library("wordcloud")
library("tm")

#necessary step for Windows
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

#to get your consumerKey and consumerSecret see the twitteR documentation for instructions
cred <- OAuthFactory$new(consumerKey='XavkeOg9cRhwgNa6aZAy4Zuv1',
                         consumerSecret='2gKMqCB6yz1T64vI18BVE3xBGLT1a7fICnKobaHDLKpaoAlBhh',
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')

# necessary step for Windows
cred$handshake(cainfo="cacert.pem")
# save for later use for Windows
save(cred, file="twitter_authentication.Rdata")

###############################################
# once saved, next time all you have to do is #
# load("twitter_authentication.Rdata")        #
# registerTwitterOAuth(cred)                  #
###############################################

#you should get TRUE
registerTwitterOAuth(cred)
#[1] TRUE

#the cainfo parameter is necessary on Windows
r_stats<- searchTwitter("#Rstats", n=1500, cainfo="cacert.pem")
#should get 1500
length(r_stats)
#[1] 1500

#save text
r_stats_text <- sapply(r_stats, function(x) x$getText())

#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))

#clean up
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower)) 
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()))
wordcloud(r_stats_text_corpus)

#alternative steps if you're running into problems 
r_stats<- searchTwitter("#Rstats", n=1500, cainfo="cacert.pem")
#save text
r_stats_text <- sapply(r_stats, function(x) x$getText())
#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))

#if you get the below error
#In mclapply(content(x), FUN, ...) :
#  all scheduled cores encountered errors in user code
#add mc.cores=1 into each function

#run this step if you get the error:
#(please break it!)' in 'utf8towcs'
r_stats_text_corpus <- tm_map(r_stats_text_corpus,
                              content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                              mc.cores=1
)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower), mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation, mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()), mc.cores=1)
wordcloud(r_stats_text_corpus)




me <- getUser("mccannecology", cainfo="cacert.pem")
me$getId()

getUser(1621088430,cainfo="cacert.pem")

me$getFollowerIDs(cainfo="cacert.pem")
#or
me$getFollowers(cainfo="cacert.pem")

#you can also see what's trending
trend <- availableTrendLocations(cainfo="cacert.pem")
head(trend)

trend <- getTrends(1, cainfo="cacert.pem")
trend
