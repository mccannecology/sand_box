load("C:/sand_box/workspace - taxi driver.RData")

# download data
library(RCurl)
URL <- "https://data.cityofnewyork.us/api/views/jb3k-j3gp/rows.csv?accessType=DOWNLOAD"
X <- getURL(URL, ssl.verifypeer = FALSE)
data <- read.csv(textConnection(X))

# examine the data 
names(data)
dim(data)
str(data)

# convert Name to a character
data$Name <- as.character(data$Name)


# clean up names - SLOW VERSION WITH A FOR LOOP 

ptm <- proc.time() # start a timer

data$last_name <- 0
data$first_name <- 0

for (i in 1:nrow(data)){
    data$last_name[i] <- strsplit(data$Name,",")[[i]][1]
    data$first_name[i] <- strsplit(data$Name,",")[[i]][2]
}

proc.time() - ptm # see how long it took 




# clean up names - FASTER VERSION
install.packages("splitstackshape")
library(splitstackshape)

ptm <- proc.time() # start a timer
data <- cSplit(data, splitCols="Name", sep=",",drop=FALSE)
proc.time() - ptm # see how long it took 

names(data)

# remove unwanted columns 
data$Name_3 <- NULL
data$Name_4 <- NULL
data$Name_5 <- NULL
data$Name_6 <- NULL


# re-arrange data for plotting 
last_names <- aggregate(data$Name_1, by=list(data$Name_1), length)
colnames(last_names)[1] <- "name"
colnames(last_names)[2] <- "count"
last_names <- last_names[order(last_names$count,decreasing=TRUE),]

first_names <- aggregate(data$Name_2, by=list(data$Name_2), length)
colnames(first_names)[1] <- "name"
colnames(first_names)[2] <- "count"
first_names <- first_names[order(first_names$count,decreasing=TRUE),]

full_names <- aggregate(data$Name, by=list(data$Name), length)
colnames(full_names)[1] <- "name"
colnames(full_names)[2] <- "count"
full_names <- full_names[order(full_names$count,decreasing=TRUE),]

# just take the top 30 
last_names_top30 <- last_names[1:30,]
first_names_top30 <- first_names[1:30,]
full_names_top30 <- full_names[1:30,]


# plotting 
library(ggplot2)

plot_first_names <- ggplot(first_names_top30, aes(reorder(name,-count),count)) + geom_bar(stat="identity")
plot_first_names <- plot_first_names + xlab("First Name") + ylab("Number")
plot_first_names <- plot_first_names + theme_classic(base_size=12)
plot_first_names <- plot_first_names + theme(axis.text.x=element_text(angle=45, hjust=1))
plot_first_names

plot_last_names <- ggplot(last_names_top30, aes(reorder(name,-count),count)) + geom_bar(stat="identity")
plot_last_names <- plot_last_names + xlab("Last Name") + ylab("Number")
plot_last_names <- plot_last_names + theme_classic(base_size=10)
plot_last_names <- plot_last_names + theme(axis.text.x=element_text(angle=45, hjust=1))
plot_last_names




# combine different version of "MOHAMMAD" into one 
names_fixed <- data 
names_fixed$Name_2[names_fixed$Name_2=="MD"] <- "MOHAMMAD"
names_fixed$Name_2[names_fixed$Name_2=="MOHAMMED"] <- "MOHAMMAD"
names_fixed$Name_2[names_fixed$Name_2=="MUHAMMAD"] <- "MOHAMMAD"
names_fixed$Name_2[names_fixed$Name_2=="MOHAMED"] <- "MOHAMMAD"

# re-aggregate
first_names_fixed <- aggregate(names_fixed$Name_2, by=list(names_fixed$Name_2), length)
colnames(first_names_fixed)[1] <- "name"
colnames(first_names_fixed)[2] <- "count"
first_names_fixed <- first_names_fixed[order(first_names_fixed$count,decreasing=TRUE),]

#  take the top 30 
first_names_fixed_top30 <- first_names_fixed[1:30,]

# replot the first names 
plot_first_names_fixed <- ggplot(first_names_fixed_top30, aes(reorder(name,-count),count)) + geom_bar(stat="identity")
plot_first_names_fixed <- plot_first_names_fixed + xlab("First Name") + ylab("Number")
plot_first_names_fixed <- plot_first_names_fixed + theme_classic(base_size=10)
plot_first_names_fixed <- plot_first_names_fixed + theme(axis.text.x=element_text(angle=45, hjust=1))
plot_first_names_fixed <- plot_first_names_fixed + annotate("text",x=27,y=0.85*max(first_names_fixed_top30$count),label="Source: NYC OpenData \n Date: Jan.9, 2015 \n By: MJ McCann \n @McCannEcology \n Code: http://bit.ly/1KOMsi9",size=2)
plot_first_names_fixed


# combining plots into one 

library(gridExtra)

first_last_names <- arrangeGrob(plot_first_names_fixed, plot_last_names)
first_last_names

ggsave("first_last_names.jpg",first_last_names,height=6,width=5)

save.image("C:/sand_box/workspace - taxi driver.RData")
