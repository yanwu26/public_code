# Load libraries
library(ggplot2)
library(stringr)

options(repr.plot.width=6, repr.plot.height=4)
#Set working directory
setwd("C:/Users/ywu/Google Drive/Working Folder/public_code/R/data/")

# Load raw data
train <- read.csv("titanic/train.csv", header = TRUE)
test <- read.csv("titanic/test.csv", header = TRUE)

# Lower case names
names(train) <-tolower(names(train))
names(test) <-tolower(names(test))
names(train)
names(test)

# Add a "Survived" variable to the test set to allow for combining data sets
test.survived <- data.frame(survived = rep("None", nrow(test)), test[,])

# Combine data sets
data.combined <- rbind(train, test.survived)

# All fields need to be converted to categorical (factor) variables
str(data.combined)
data.combined$survived <- as.factor(data.combined$survived)
data.combined$pclass <- as.factor(data.combined$pclass)

# Take a look at gross survival rates and priority classes
table(data.combined$survived)
table(data.combined$pclass)

# Hypothesis - Rich folks survived at a higer rate
#convert to factor first, and then plot
train$pclass <- as.factor(train$pclass)
train$survived <- as.factor(train$survived)
ggplot(train, aes(x = pclass, fill = survived))   +  geom_bar(serialize()) +
  xlab("Pclass")   +
  ylab("Total Count") +
  labs(fill = "Survived") 


##Get rid of duplicates

# Unique names
length(unique(as.character(data.combined$name)))

#show me the duplicates
dup.names <- as.character(data.combined[which(duplicated(as.character(data.combined$name))), "name"])
data.combined[which(data.combined$name %in% dup.names),]
#this appears that they simply have duplicate names

## Let's take a look at Miss, Mrs, and Males
misses <- data.combined[which(str_detect(data.combined$name, "Miss.")),]
misses[1:10,]

mrses <- data.combined[which(str_detect(data.combined$name, "Mrs.")), ]
mrses[1:10,]

males <- data.combined[which(data.combined$sex == "male"), ]
males[1:10,]

# We see that there's some relationship between having titles related to survivability. 
# Let's make a function to add this as a column

extractTitle <- function(name) {
  name <- as.character(name)
  
  if (length(grep("Miss.", name)) > 0) {
    return ("Miss.")
  } else if (length(grep("Master.", name)) > 0) {
    return ("Master.")
  } else if (length(grep("Mrs.", name)) > 0) {
    return ("Mrs.")
  } else if (length(grep("Mr.", name)) > 0) {
    return ("Mr.")
  } else {
    return ("Other")
  }
}


#create a title
titles <- NULL
for (i in 1:nrow(data.combined)) {
  titles <- c(titles, extractTitle(data.combined[i,"name"]))
}
data.combined$title <- as.factor(titles)

# Since we only have survived lables for the train set, only use the
# first 891 rows
ggplot(data.combined[1:891,], aes(x = title, fill = survived)) +
  stat_count(width = 0.5) +  facet_wrap(~pclass) + 
  ggtitle("Pclass") + xlab("Title of Passenger") + ylab("Total Count") + labs(fill = "Survived")



