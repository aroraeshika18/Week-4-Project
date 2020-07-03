## download and unzip files
fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile= "C:\\Eshika Files\\Coursera\\Data Science foundations\\data.zip")
unzip("data.zip", exdir = "C:\\Eshika Files\\Coursera\\Data Science foundations")
rm("data.zip")
file.remove("data.zip")

## read data
xtest<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\test\\X_test.txt")
xtrain<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\train\\X_train.txt")
ytest<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\test\\y_test.txt")
ytrain<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\train\\y_train.txt")
subjecttest<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\test\\subject_test.txt")
subjecttrain<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\train\\subject_train.txt")
activitylables<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\activity_labels.txt")
features<- read.table("C:\\Eshika Files\\Coursera\\Data Science foundations\\UCI HAR Dataset\\features.txt")

## Merge data
featuresdata<- rbind(xtest, xtrain)
activitydata<- rbind(ytest, ytrain)
subjectdata<- rbind(subjecttest, subjecttrain)

##Extract required measurements
variablesneeded<- features[grep(".*mean\\(\\)|std\\(\\)", features[,2]),]
featuresdata2<- featuresdata[,variablesneeded[,1]]

## Labelling dataset
colnames(featuresdata2)<- variablesneeded[,2]
colnames(activitydata)<- "activity"
colnames(subjectdata)<- "subject"

## Tidy datset with average of each variable 
finaldataset<- cbind(subjectdata, activitydata, featuresdata2)
finaldataset$activity<- fator(finaldataset$activity, levels= activitylables[,1], labels= activitylables[,2])
finaldataset$activity<- factor(finaldataset$activity, levels= activitylables[,1], labels= activitylables[,2])
str(finaldataset$subject)
finaldataset$subject<- as.factor(finaldataset$subject)
library(dplyr)
tidydataset<- finaldataset %>% group_by(activity, subject) %>% summarize(mean())
tidydataset<- finaldataset %>% group_by(activity, subject) %>% summarize_all(list(mean))
write.table(tidydataset, file = "./tidydataset.txt", row.names = F, col.names = T)

