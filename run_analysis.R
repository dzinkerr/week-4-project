#QUESTION 1:
#FIrst question asks to create Data Table with the training and data sets.

#Read file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#unzip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#getting useful data
path <- file.path("./data" , "UCI HAR Dataset")
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

#Creating Data Table Columns
activityColumn <- rbind(activityTrain,activityTest)
subjectColumn <- rbind(subjectTrain,SubjectTest)
featuresColumn <- rbind(featuresTrain,featuresTest)

#Naming Comlumns
names(subjectColumn) <- "subject"
names(activityColumn) <- "activity"
featuresNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(featuresColumn) <- featuresNames[,2]

#Column binding to creata Final Data TabBle
FinalData <- cbind(featuresColumn,subjectColumn,activityColumn)

## !!!!  END OF QUESTION 1  !!!!

##QUESTION 2:
##Question two asks to get measurements of the mean and standard deviation for the measuremnets.

names2<-c(grep("mean\\(\\)|std\\(\\)", featuresNames[,2],value=TRUE), "subject", 
                 "activity" )
Data2<-subset(FinalData,select=names2)

## !!!!  END OF QUESTION 2  !!!!

##QUESTION 3:
##Questione three asks you to substitute the integer values in the activity column for descriptive
##values.
activities<- read.table(file.path(path, "activity_labels.txt" ),header = FALSE)
Data2$activity<-activities[,2][Data2$activity]

## !!!!  END OF QUESTION 3 !!!!

##QUESTION 4:
##Replaces non human understandable names for descriptive names
names(Data2)<-gsub("^t", "Time", names(Data2))
names(Data2)<-gsub("^f", "Frequency", names(Data2))
names(Data2)<-gsub("Acc", "Accelerometer", names(Data2))
names(Data2)<-gsub("BodyBody", "Body", names(Data2))
names(Data2)<-gsub("Gyro", "Gyroscope", names(Data2))
names(Data2)<-gsub("Mag", "Magnitude", names(Data2))

## !!!!  END OF QUESTION 4  !!!!

##QUESTION 5:
##asks to create a second seperate tidy data set for submision

library(dplyr)
tidy <- Data2 %>% group_by(activity,subject)
tidy <-summarise_all(tidy,mean)
write.table(tidy, file = "tidy.txt", row.names = FALSE)

    