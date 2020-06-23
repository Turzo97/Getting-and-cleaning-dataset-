
##getting & cleaning data project

setwd("C:\\Users\\Turzo\\Desktop\\c.course,R\\Getting-and-cleaning-dataset-")

## Downloading process 

      if(!file.exists("./project")){dir.create("./project")} 
    Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(Url,destfile="./project/Dataset.zip")
      unzip(zipfile="./project/Dataset.zip",exdir="./project")
    filepath <- file.path("./project" , "UCI HAR Dataset")   
    files<-list.files(filepath, recursive=TRUE)
    files

#their exist this diffrent kinds of value for existing variable.
##test/subject_test.txt, test/X_test.txt, test/y_test.txt ,train/subject_train.txt ,train/X_train.txt ,train/y_train.txt 


## reading Activity files

library(data.table)
Activity_Test  <- read.table(file.path(filepath, "test" , "Y_test.txt" ),header = FALSE)
Activity_Train <- read.table(file.path(filepath, "train", "Y_train.txt"),header = FALSE) 
str(Activity_Test)
str(Activity_Train)

## Reading Feature files

Features_Test  <- read.table(file.path(filepath, "test" , "X_test.txt" ),header = FALSE)
Features_Train <- read.table(file.path(filepath, "train", "X_train.txt"),header = FALSE)
str(Features_Test)
str(Features_Train)

## Reading Subject files

Subject_Train <- read.table(file.path(filepath, "train", "subject_train.txt"),header = FALSE)
Subject_Test  <- read.table(file.path(filepath, "test" , "subject_test.txt"),header = FALSE)
str(Subject_Test)
str(Subject_Train)  

##MARGING PROCESS

##asigning table by rows   

Activity<-rbind(Activity_Train,Activity_Test)
Subject<-rbind(Subject_Train,Subject_Test)
Features<-rbind(Features_Train,Features_Test)
## asigning variable names
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(filepath, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

## Column merging for getting data frame

datCombine <- cbind(Subject, Activity)
Data <- cbind(Features, datCombine)

#Subset Name of Features by measurements on the mean and standard deviation

subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

##Subseting the data frame 'Data' by seleted names of Features
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

###adding descriptive values for activity labels 
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)
## creating tidy dataset

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

