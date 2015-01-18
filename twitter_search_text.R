# http://www.rdatamining.com/examples/text-mining

library(twitteR)

load("twitter_authentication.Rdata")        
registerTwitterOAuth(cred)                  

###################
# Retrieve tweets # 
###################

# retrieve the first 100 tweets (or all tweets if fewer than 100)
# from the user timeline of @rdatammining
rdmTweets <- userTimeline("mccannecology", n=100, cainfo="cacert.pem")
n <- length(rdmTweets)
rdmTweets[1:3]

##################### 
# Transforming Text #
#####################
# The tweets are first converted to a data frame and then to a corpus.

df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)

library(tm)
# build a corpus, which is a collection of text documents
# VectorSource specifies that the source is character vectors.
myCorpus <- Corpus(VectorSource(df$text))


# After that, the corpus needs a couple of transformations, 
# including changing letters to lower case, 
# removing punctuations/numbers and removing stop words. 
# The general English stop-word list is tailored by adding "available" and "via" and removing "r".

myCorpus <- tm_map(myCorpus, tolower)
# try this instead 
# myCorpus <- tm_map(myCorpus, content_transformer(tolower))
# as per: http://stackoverflow.com/questions/24771165/r-project-no-applicable-method-for-meta-applied-to-an-object-of-class-charact


# remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)

# remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)

# remove stopwords
# keep "r" by removing it from stopwords
myStopwords <- c(stopwords('english'), "available", "via")
idx <- which(myStopwords == "r")
myStopwords <- myStopwords[-idx]
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)


################## 
# Stemming Words #
##################
# In many cases, words need to be stemmed to retrieve their radicals. 
# For instance, "example" and "examples" are both stemmed to "exampl". 
# However, after that, one may want to complete the stems to their original forms, 
# so that the words would look "normal".

dictCorpus <- myCorpus

# stem words in a text document with the snowball stemmers,
# which requires packages Snowball, RWeka, rJava, RWekajars
myCorpus <- tm_map(myCorpus, stemDocument)

# inspect the first three ``documents"
inspect(myCorpus[1:3])

# stem completion
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=dictCorpus)     ### THIS COMMAND HAS PROBLEMS


################################### 
# Building a Document-Term Matrix #
###################################
myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
inspect(myDtm[266:270,31:40])

###################################
# Frequent Terms and Associations #
###################################
findFreqTerms(myDtm, lowfreq=10)

# which words are associated with "r"?
findAssocs(myDtm, 'r', 0.30)

# which words are associated with "mining"?
# Here "miners" is used instead of "mining",
# because the latter is stemmed and then completed to "miners". :-( 
findAssocs(myDtm, 'miners', 0.30)


############## 
# Word Cloud #
##############
library(wordcloud)
m <- as.matrix(myDtm)
# calculate the frequency of words
v <- sort(rowSums(m), decreasing=TRUE)
myNames <- names(v)
k <- which(names(v)=="miners")
myNames[k] <- "mining"
d <- data.frame(word=myNames, freq=v)
wordcloud(d$word, d$freq, min.freq=3)