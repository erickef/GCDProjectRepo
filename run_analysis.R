## Getting and Cleaning Data Course Project
## Author: Erick J. Elizalde Figueroa 

## Download and unzip the data.
## link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## link <- sub("^https", "http", link)
## download.file(link)
## unzip("data.zip", exdir="unziped")
## setwd("unziped")

##STEP 1 - Merges the training and the test sets to create one data set.

## Load the files with information for replace activity and variables names.
features <- read.table("features.txt")
#flabels <- read.table("activity_labels.txt")

## Load each file from train directory/subdirectories to a table
subject_train <- read.table("train/subject_train.txt")
## Assign name to the subject variable
names(subject_train) <- "subjectId"
y_train <- read.table("train/y_train.txt")
## Assing name to the activity variable 
names(y_train) <- "activity"
X_train <- read.table("train/X_train.txt")
names(X_train) <- features$V2

## Combine the train datatables.
train_data <- cbind(subject_train, y_train, X_train)

## Load each file from test directory/subdirectories to a table
subject_test <- read.table("test/subject_test.txt")
names(subject_test) <- "subjectId"
y_test <- read.table("test/y_test.txt")
names(y_test) <- "activity"
X_test <- read.table("test/X_test.txt")
names(X_test) <- features$V2

## Combine the test datatables.
test_data <- cbind(subject_test, y_test, X_test)

## Combine the two datasets
complete <- rbind(train_data, test_data)

##STEP 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

## Filter columns 
colIndex <- grepl("mean\\(\\)", names(complete))|grepl("std\\(\\)", names(complete))
## Keep the subject and the activity cols.
colIndex[1:2] <- TRUE
filteredDT <- complete[, colIndex]

## STEP 3 - Uses descriptive activity names to name the activities in the data set

## Replace the activity id with char description.
filteredDT$activity <- factor(filteredDT$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

## STEP 4 - Appropriately labels the data set with descriptive variable names.

## Clean up the columns names from special chars.
library(stringr)
conam <- names(filteredDT)
names(filteredDT) <- str_replace_all(conam, "[[:punct:]]", "")


## STEP 5 - From the data set in step 4, creates a second, independent tidy data set with the 
##          average of each variable for each activity and each subject.

library(plyr)
tidyDataSet <- ddply(filteredDT, .(subjectId, activity), numcolwise(mean))
write.table(tidyDataSet, "tidyDataSet.txt", row.names = FALSE)
