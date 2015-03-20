# Main

library("data.table")
library("plyr")
library("dplyr")

url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "UCI HAR Dataset.zip"
method <- "curl"

download.file(url, destfile = destfile, method = "curl")

dateDownloaded <- date()
dateDownloaded

unzip(destfile)

dataSetName <- "UCI HAR Dataset"
setwd(dataSetName)

# Merge the training and the test sets to create one data set.
x <- read.table("test/subject_test.txt")
y <- read.table("train/subject_train.txt")
subject <- rbind(x, y)
names(subject) <- "Subject"

x <- read.table("test/X_test.txt")
y <- read.table("train/X_train.txt")
# bigX
#     - rows = feature by subject
#     - columns = feature
bigX <- rbind(x, y)

x <- read.table("test/y_test.txt")
y <- read.table("train/y_train.txt")
activityID <- rbind(x, y)
names(activityID) <- "ActivityID"

features <- read.table("features.txt")

# Clean up the column names
features[,2] <- gsub("[\\(\\)]", "", features[,2])
features[,2] <- gsub("[\\,\\-]", "_", features[,2])

# Set correct variable names 
setnames(bigX, features[,2])

# Remove duplicate columns
bigX <- bigX[, unique(colnames(bigX))]

# Remove unwanted columns
z <- sort(append(grep("mean", names(bigX)),grep("std", names(bigX))))
bigX <- bigX[,z]

# Save these column names for later use
goodCols <- colnames(bigX)

# Add subject numbers to each observation
bigX <- cbind(bigX, subject)

# Add the respective activityID to each observation
bigX <- cbind(bigX, activityID)

# Use descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("Index", "Activity")
for(i in 1:nrow(bigX)) {
  bigX$Activity[i] <- as.vector(activity_labels[bigX$ActivityID[i],2])
}

tidy_averages <- bigX[goodCols] %>%
  aggregate(by=bigX[c("Subject","Activity")], FUN=mean) %>%
  arrange(Subject, Activity)

write.table(tidy_averages, file="tidy_averages.txt")
