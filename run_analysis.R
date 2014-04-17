
load_data <- function()
{
  adl_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  adl_file <- "getdata_projectfiles_UCI HAR Dataset.zip"
  
  if(!file.exists(adl_file)) download.file(adl_url, adl_file, method="curl")
  
  if(!file.exists("UCI HAR Dataset")) unzip(adl_file)
}

load_test <- function(rows=10)
{
  alt <- read.table("UCI HAR Dataset//activity_labels.txt", header=F, col.names=c("activity_id","activity_label"), nrows=rows)
  aoTest <- read.table("UCI HAR Dataset//test//y_test.txt", header=F, col.names=c("activity_id"), nrows=rows)
  subTest <- read.table("UCI HAR Dataset//test//subject_test.txt", header=F, col.names=c("sub_id"), nrows=rows)
  aoTrain <- read.table("UCI HAR Dataset//train//y_train.txt", header=F, col.names=c("activity_id"), nrows=rows)
  subTrain <- read.table("UCI HAR Dataset//train//subject_train.txt", header=F, col.names=c("sub_id"), nrows=rows)
  
  tst <- read.table("UCI HAR Dataset/test/X_test.txt", header=F, colClasses=rep("numeric", times=561), comment.char="", nrows=rows)
#  message(print(object.size(tst), units="Mb"))
  train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F, colClasses=rep("numeric", times=561), comment.char="", nrows=rows)
#  message(print(object.size(train), units="Mb"))
  
  features <- read.table("UCI HAR Dataset/features.txt", colClasses=c("numeric","character"))
  features$V2 <- gsub("\\(\\)","",features$V2)
  features$V2 <- gsub("-","_",features$V2)
  features$V2 <- gsub("BodyBody","Body",features$V2)
  names(tst) <- features$V2
  names(train) <- features$V2
  
  colSel <- names(tst[,grep("mean_|std_", names(tst))])
  
  actSet <- rbind(merge(aoTest, alt), merge(aoTrain, alt))

  fullSet <- rbind(tst, train)

  selSet <- fullSet[,colSel]
  cbind(rbind(subTest,subTrain), actSet, selSet)
  #read headers and prepare col classes vector; set comments character to empty
  #read small part to estimate time
  #read whole file
}

load_data()
load_test()

#harm <- melt(har, id=(c("sub_id","activity_label")))
#har2 <- dcast(harm, sub_id + activity_label ~ variable, mean)
#write.table(har2, "test.txt")