if(!file.exists("./c3")){dir.create("./c3")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./c3/Dataset.zip",method="curl")
unzip(zipfile="./c3/Dataset.zip",exdir="./c3")
fpath <- file.path("./c3" , "UCI HAR Dataset")

## Read all the files
DataActivityTest  <- read.table(file.path(fpath, "test" , "Y_test.txt" ),header = FALSE)
DataActivityTrain <- read.table(file.path(fpath, "train", "Y_train.txt"),header = FALSE)
DataSubjectTrain <- read.table(file.path(fpath, "train", "subject_train.txt"),header = FALSE)
DataSubjectTest  <- read.table(file.path(fpath, "test" , "subject_test.txt"),header = FALSE)
DataFeaturesTest  <- read.table(file.path(fpath, "test" , "X_test.txt" ),header = FALSE)
DataFeaturesTrain <- read.table(file.path(fpath, "train", "X_train.txt"),header = FALSE)

## Combine different Training and Testing Data
DataSubject <- rbind(DataSubjectTrain, DataSubjectTest)
DataActivity <- rbind(DataActivityTrain, DataActivityTest)
DataFeatures <- rbind(DataFeaturesTrain, DataFeaturesTest)

## Name the colums and combine Subjects and Activity Data
names(DataSubject) <- c("subject")
names(DataActivity) <- c("activity")
DataFeaturesNames <- read.table(file.path(fpath, "features.txt"),header = FALSE)
names(DataFeatures) <- DataFeaturesNames$V2
DataCombine <- cbind(DataSubject, DataActivity)

##Merges the training and the test sets to create one Data set.
MainData <- cbind(DataFeatures, DataCombine)

##Extracts only the measurements on the mean and standard deviation for each measurement.
subDataFeaturesNames <- DataFeaturesNames$V2[grep("(mean|std)\\(\\)", DataFeaturesNames$V2)]

##Uses descriptive activity names to name the activities in the Data set
selectedNames <- c(as.character(subDataFeaturesNames), "subject", "activity" )
MainData <- subset(MainData,select=selectedNames)
activityLabels <- read.table(file.path(fpath, "activity_labels.txt"),header = FALSE)

##Appropriately labels the Data set with descriptive variable names.
names(MainData) <- gsub("^t", "time", names(MainData))
names(MainData) <- gsub("^f", "frequency", names(MainData))
names(MainData) <- gsub("Acc", "Accelerometer", names(MainData))
names(MainData) <- gsub("Gyro", "Gyroscope", names(MainData))
names(MainData) <- gsub("Mag", "Magnitude", names(MainData))
names(MainData) <- gsub("BodyBody", "Body", names(MainData))

##From the Data set in step 4, creates a second, independent tidy Data set with the average of each variable for each activity and each subject.
library(plyr);
MainData2 <- aggregate(. ~subject + activity, MainData, mean)
MainData2 <- MainData2[order(MainData2$subject,MainData2$activity),]
write.table(MainData2, file = "tidyMainData.txt",row.name = FALSE)
