# Getting and Cleaning Data Project
The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. 

This file describes briefly what the provided script does and its dependencies. 


### Main script

R script called run_analysis.R does the following: 
  0. Downloads the UCI HAR Dataset and unzips it if not already available on local disk. Loads the test, training set and the descriptive files.
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive activity names. 
  5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  6. Writes the results into a file "uci_har_tidy2.txt".

**Example:** source("run_analysis.R")


### Required packages

The script requires following packages to run:
 - reshape
 - reshape2
 