---
title: "README"
author: "Tom Pierce"
date: "Friday, March 21, 2015"
output: html_document
---

#README

##Tidy Data Assignment

###Assignment

You should create one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Product

The starting data set is downloaded and processed with the "run_analysis.R" R script. The output of this script is a "tidy" data set containing the average of each variable for each activity and each subject. The first column is the subject number and the second column is the activity. Each row represents averages for each variable by subject and activity.
