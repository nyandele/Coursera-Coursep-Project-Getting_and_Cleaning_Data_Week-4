ls()
rm(list = ls())

library(dplyr)

# Download the dataset and uzip the folder
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(url, "getdata_projectfiles_UCI HAR Dataset.zip")
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# Reading the dataframes from the unzipped folder
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge the training and test sets to create a single dataset
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

#Extract only the measurements on the mean and standard deviation for each measurement
names(Merged_Data)
TidyData <- Merged_Data %>% 
  select(subject, code, contains("mean"), contains("std"))

#Replace codes with descriptive names in the Tidy data set (TidyData)
TidyData$code <- activities[TidyData$code, 2]
names(TidyData)

#Label all variables in the tidy data set with descriptive names
names(TidyData)[2] <- "activity" 
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))

#Create an independent tidy dataset with the average of each variable for each
## activity per subject
FinalData <- TidyData %>% 
  group_by(subject, activity) %>% 
  summarise_all(funs(mean))
# export the final data in txt format
FinalData
str(FinalData)
write.table(FinalData, "FinalData.txt", row.names = FALSE)






























































































































