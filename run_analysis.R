# Main

library("data.table")
library("plyr")
library("dplyr")
library("readr")

# Download and unzip the data set.
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "UCI HAR Dataset.zip"
method <- "curl"
download.file(url, destfile = destfile, method = "curl")
# Record date and time of download
write_file(date(), "DateDownloaded.txt")
unzip(destfile)

# Start reading and merging of data files. Merge files in "test"
# directory with files in the "train" directory. Structure and filenames
# are identical between both directories.
dataSetName <- "UCI HAR Dataset"
setwd(dataSetName)

# Merge the training and the test sets to create one data set.
# x and y are temporary "scratch" objects.
x <- read.table("test/subject_test.txt")
y <- read.table("train/subject_train.txt")
subject <- rbind(x, y)
names(subject) <- "Subject"

x <- read.table("test/X_test.txt")
y <- read.table("train/X_train.txt")
# bigX - Combined test and train data sets.
#     - rows = feature by subject
#     - columns = feature
bigX <- rbind(x, y)

# Merge files conataining Activity ID for each observation.
x <- read.table("test/y_test.txt")
y <- read.table("train/y_train.txt")
activityID <- rbind(x, y)
names(activityID) <- "ActivityID"

# Read file containing variable names
features <- read.table("features.txt")

# Clean up the variable names. Some of the upcoming utilities
# barf on "special" characters in variable names.
features[,2] <- gsub("[\\(\\)]", "", features[,2])
features[,2] <- gsub("[\\,\\-]", "_", features[,2])

# Set correct variable names 
setnames(bigX, features[,2])

# Remove duplicate variable names. Some of the upcoming utilities
# barf on duplicate variable names.
bigX <- bigX[, unique(colnames(bigX))]

# Remove unwanted columns. Z is used to "mask" for wanted variables 
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

# Tidy up the data set and calculate desired averages.
tidy_averages <- bigX[goodCols] %>%
  aggregate(by=bigX[c("Subject","Activity")], FUN=mean) %>%
  arrange(Subject, Activity)

# Save the tidy data set.
write.table(tidy_averages, file="tidy_averages.txt")
