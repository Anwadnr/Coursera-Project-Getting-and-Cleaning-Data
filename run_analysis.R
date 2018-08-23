# Coursera Data Science Specialization
# Getting and Cleaning Data
# -----------------

# Load in packages

library(dplyr)
library(data.table)
library(reshape2)
library(tidyr)
library(knitr)


# Read in data from working directory "UCI HAR Dataset"

DataActivity_Test  <- 
  read.table("test/y_test.txt")
DataActivity_Train <- 
  read.table("train/y_train.txt")

DataSubject_Train <- 
  read.table("train/subject_train.txt")
DataSubject_Test  <- 
  read.table("test/subject_test.txt")

DataFeatures_Test  <- 
  read.table("test/X_test.txt")
DataFeatures_Train <- 
  read.table("train/X_train.txt")

DataFeatures_Names<- 
  read.table("features.txt")

# Merging training and test sets  

Data_Subject <- 
  rbind(DataSubject_Train, DataSubject_Test)
Data_Activity<- 
  rbind(DataActivity_Train, DataActivity_Test)
DataFeatures<- 
  rbind(DataFeatures_Train, DataFeatures_Test)

names(Data_Subject)<-
  c("subject")
names(Data_Activity)<- 
  c("activity")
names(DataFeatures)<- 
  DataFeatures_Names$V2

Data_Combine <- 
  cbind(Data_Subject, Data_Activity)
Data <- 
  cbind(DataFeatures, Data_Combine)

# Extracting mean and standard deviation for each measurement

FeaturesNames_Sub<-
  DataFeatures_Names$V2[grep("mean\\(\\)|std\\(\\)", DataFeatures_Names$V2)]

SelectedNames <- 
  c(as.character(FeaturesNames_Sub), "subject", "activity" )

Data<-
  subset(x= Data, select = SelectedNames)

# Nameing activities in data set

Activity_Labels <- 
  read.table(("activity_labels.txt"), header = FALSE)
Data$activity <- 
  factor(Data$activity)
Data$activity <- 
  factor( x = Data$activity,labels = as.character(Activity_Labels$V2))

# Adjusing labels with descriptive variable names

names(Data)<-
  gsub("^t", "time", names(Data))
names(Data)<-
  gsub("^f", "frequency", names(Data))
names(Data)<-
  gsub("Acc", "Accelerometer", names(Data))
names(Data)<-
  gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-
  gsub("Mag", "Magnitude", names(Data))
names(Data)<-
  gsub("BodyBody", "Body", names(Data))

# Creating tidy data set

Data2<-
  aggregate(. ~subject + activity, Data, mean)
Data2<-
  Data2[order(Data2$subject, Data2$activity),]

write.table(Data2, file = "tidydata.txt", row.name = FALSE)


          