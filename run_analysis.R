# this function downloads UCI HAR data set and unzips it if not yet done
load_data <- function()
{
  dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dataFile <- "getdata_projectfiles_UCI HAR Dataset.zip"
  
  if(!file.exists(dataFile)) download.file(dataURL, dataFile, method="curl")
  
  if(!file.exists("UCI HAR Dataset")) unzip(dataFile)
}

# This function does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# 6. Writes the results into a file "uci_har_tidy2.txt".
run_analysis <- function()
{
  # load libraries
  library(reshape)
  library(reshape2)
  
  # rows used to limit data during tests
  rows<--1
  actLabels <- read.table("UCI HAR Dataset//activity_labels.txt", header=F, col.names=c("activityId","activityLabel"))

  # read test labels and subject set
  aoTest <- read.table("UCI HAR Dataset//test//y_test.txt", header=F, col.names=c("activityId"), nrows=rows)
  subTest <- read.table("UCI HAR Dataset//test//subject_test.txt", header=F, col.names=c("subId"), nrows=rows)

  # read train labels and subject set
  aoTrain <- read.table("UCI HAR Dataset//train//y_train.txt", header=F, col.names=c("activityId"), nrows=rows)
  subTrain <- read.table("UCI HAR Dataset//train//subject_train.txt", header=F, col.names=c("subId"), nrows=rows)
  
  # read the test and train measures
  # parameters used to increase performance: 
  # - set column classes vector 
  # - set comments character to empty
  featureClasses <- rep("numeric", times=561) 
  testMeasures <- read.table("UCI HAR Dataset/test/X_test.txt", header=F, colClasses=featureClasses, comment.char="", nrows=rows)
  trainMeasures <- read.table("UCI HAR Dataset/train/X_train.txt", header=F, colClasses=featureClasses, comment.char="", nrows=rows)
  
  # prepare feature header columns
  features <- read.table("UCI HAR Dataset/features.txt", colClasses=c("numeric","character"))

  # cleanse feature header columns
  features$V2 <- gsub("-mean\\(\\)-","Mean",features$V2)
  features$V2 <- gsub("-std\\(\\)-","Std",features$V2)
  features$V2 <- gsub("BodyBody","Body",features$V2)
  names(testMeasures) <- features$V2
  names(trainMeasures) <- features$V2
  
  # merge test and train set
  fullSet <- rbind(testMeasures, trainMeasures)

  # pick only measures on mean and standard deviation
  colSel <- names(fullSet[,grep("Mean[X-Z]|Std[X-Z]", names(fullSet))])
  selSet <- fullSet[,colSel]
  
  # translate activity ids to activity labels
  actSet <- rbind(merge(aoTest, actLabels), merge(aoTrain, actLabels))["activityLabel"]
  
  # combine subject, activity and measures columns into one frame
  subSet <- rbind(subTest,subTrain)
  tidySet1 <- cbind(subSet, actSet, selSet)
  #write.table(tidySet1, "tidy_set1.txt", row.names=FALSE)
  
  # aggregate data using averages
  tidySet1Melt <- melt(tidySet1, id=(c("subId","activityLabel")))
  tidySet2 <- dcast(tidySet1Melt, subId + activityLabel ~ variable, mean, na.rm=T)
  write.table(tidySet2, "uci_har_tidy2.txt", row.names=FALSE)
}

load_data()
run_analysis()