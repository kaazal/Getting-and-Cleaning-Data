#OVERVIEW
#From the database featured from the Samsung Galaxy smartphone,data was collected and cleaned resulting to the output of a Tidy data

#Download the file

zipfile <- "UCI HAR Dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="UCI HAR Dataset.zip")
dataPath <- "UCI HAR Dataset"

#unzip the file

if(!file.exists(dataPath)) {
  unzip(zipfile)
}

#read features

features <- read.table(file.path(dataPath, "features.txt"))

vfeatures <- as.vector(features$V2)
#read Train data

X_train <- read.table(file.path(dataPath, "train", "X_train.txt"))

y_train <- read.table(file.path(dataPath,"train", "y_train.txt"))
subject_train <- read.table(file.path(dataPath,"train","subject_train.txt"))

#Assigning column names(Train data)

colnames(y_train) <- "Activity"
colnames(subject_train) <- "Subject"

colnames(X_train) <- vfeatures
#concatenate Train set

Train <- cbind(subject_train,y_train,X_train)

#read Test data

X_test <- read.table(file.path(dataPath,"test","X_test.txt"))
y_test <- read.table(file.path(dataPath,"test", "y_test.txt"))
subject_test <- read.table(file.path(dataPath,"test","subject_test.txt"))

#Assingning column names(Test data)

colnames(X_test) <- vfeatures
colnames(y_test) <- "Activity"
colnames(subject_test) <- "Subject"
Test <- cbind(subject_test,y_test,X_test)

#merge both Train and Test Tables

merge <- rbind(Train,Test)

#read activity_labels

activity_labels <- read.table(file.path(dataPth,"activity_labels.txt"))

#Extracting mean and standard deviation

meanstd <- merge[, grep("mean|std|Subject|Activity", colnames(merge))]

#library(dplyr)
#Naming descriptive activity names in the dataset

meanstd <- mutate(meanstd, Activity = activity_labels[as.integer(meanstd$Activity), 2])

#Dataset with descriptive variable names


names(meanstd) <- gsub("Acc"," Accelerometer",names(meanstd))
names(meanstd) <- gsub("^t","time",names(meanstd))          
names(meanstd) <- gsub("fBody","frequency Body",names(meanstd))
names(meanstd) <- gsub("BodyBody","Body",names(meanstd))
names(meanstd) <- gsub("Mag","Magnitude",names(meanstd))
names(meanstd) <- gsub("std", " Standardeviation",names(meanstd))
names(meanstd) <- gsub("Freq"," Frequency",names(meanstd))
names(meanstd) <- gsub("BodyGyro","Body Gyro",names(meanstd))
names(meanstd) <- gsub("mean"," Mean",names(meanstd))
names(meanstd) <- gsub("Gyro","Gyroscope", names(meanstd))
names(meanstd) <- gsub("-","",names(meanstd))
names(meanstd) <- gsub("[][()]","",names(meanstd))

#Average for each variable for each activity

AvgMean <- meanstd %>% 
  group_by(Subject,Activity) %>% 
  summarise_all(funs(mean))

#Independent tidy dataset

write.table(AvgMean, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)









