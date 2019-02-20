
library (dplyr)

# Downlad and unzip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# Download training dataset and training subjects data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Download test dataset and test subjects data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt', header = FALSE)

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt', header = FALSE)

# Variable names
colnames(y_train) <- "activity_id"
colnames(x_train) <- features[,2]
colnames(subject_train) <- "subject_id"

colnames(y_test) <- "activity_id"
colnames(x_test) <- features[,2]
colnames(subject_test) <- "subject_id"

colnames(activityLabels) <- c("activity_id", "subject_id")

# merge
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
traintest <- rbind(mrg_train, mrg_test)

names <- colnames(traintest)

# grepl makes logical vector where  those words are in the colnames
mean_std <- (grepl("activity_id" , names) | 
                                   grepl("subject_id" , names) | 
                                   grepl("mean.." , names) | 
                                   grepl("std.." , names))

traintest_st <- traintest[ ,mean_std == TRUE]

traintest_labels <- merge(traintest_st, activityLabels,
                              by='activity_id',
                              all.x = TRUE)

colnames(traintest_labels)[2] <- "subject_id"

tidy <- aggregate(. ~subject_id + activity_id, traintest_labels, mean)
tidy <- tidy[order(tidy$subject_id, tidy$activity_id),]

write.table(tidy, "tidy_c3w4.txt", row.name=FALSE)

