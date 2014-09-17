## After unzipping the data file, rename the folder ''UCI HAR Dataset' as 'dataset'
## Run this R script 

## Reading of the data in test dataset
xtest <- read.table("dataset/test/X_test.txt")
ytest <- read.table("dataset/test/y_test.txt")
id <- read.table("dataset/test/subject_test.txt")
test <- data.frame(id, ytest, xtest)

## Reading of data in the training dataset

xtrain <- read.table("dataset/train/X_train.txt")
ytrain <- read.table("dataset/train/y_train.txt")
id <- read.table("dataset/train/subject_train.txt")
train <- data.frame(id, ytrain, xtrain)

## Merging the 2 data frames containing training and test data

fullset <- rbind(test,train)

## Reading the labels

features <- read.table("dataset/features.txt", colClasses = "character")
names(features) <- c("row.Names", "label")

## Adding the features labels to merged data

names(fullset) <- c("id", "activity", features$label)

## Selecting only the mean and standard deviations of measures (note that dplyr package needed)

library(dplyr)
tidydat <- select(fullset, id, activity, contains("mean()"), contains("std()"), -contains("meanFreq()"), -contains("angle"))

## Adding the activity labels to the merged data, creating the tidy data requested in Step 4

actlab <- read.table("dataset/activity_labels.txt", colClasses = "character")
names(actlab) <- c("refcode", "activity")
tidydat$activity <- as.factor(tidydat$activity)
levels(tidydat$activity) <- actlab$activity

write.table(tidydat, file = "tidydata_step4.txt", row.names = FALSE)

## Summarizing Data and then producing tidy data requested in Step 5

tidydatgrp <- group_by(tidydat, id, activity)
tidydata <- summarise_each(tidydatgrp, funs(mean))
write.table(tidydata, file = "tidydata_step5.txt", row.names = FALSE)
