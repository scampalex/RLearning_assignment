

## This script loads the following files, merges them into a single dataset, 
## then extacts the mean and SD for each of the measurements: 
##
##  - test/X_test.txt
##  - train/X_train.txt
## 
## Some toolboxes needed: 
library(dplyr)

##Load raw data: 
file_test <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"
test_data <- read.table(file_test, header = FALSE) # this returns a table of 2947 x 561 

file_train <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
train_data <- read.table(file_train,header = FALSE)

# Row names: 
filename_testH <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
test_head <- read.table(filename_testH)

filename_trainH <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"
train_head <- read.table(filename_trainH)


# Column names: 
filename_features <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt"
features <- read.table(filename_features)

# Subject details: 
filename_subjectTrain <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"
filename_subjectTest <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"

subject_train <- read.table(filename_subjectTrain)
subject_test <- read.table(filename_subjectTest)

# Add column and row titles to datasets:
for (i in 1:561) {
  colnames(train_data)[i] <- features[i,2]
  colnames(test_data)[i] <- features[i,2]
}

colnames(train_head) <- "activity_pace"
colnames(test_head) <- "activity_pace"


train_data2 <- cbind(train_head,train_data)
test_data2 <- cbind(test_head, test_data)

# Combine the test and training datasets 
combined <- rbind(train_data2,test_data2)

# Locating the mean and std ccolumns: 
index_features <- grep("mean|std",features$V2)

activity_type <- combined[,1] # saving the column names 
subject_combined <- rbind(subject_train,subject_test) 
colnames(subject_combined) <- "Subjects"
combined_2 <- combined[,2:562] # removing the column names so column indexes match the features list 

filtered_combined <- combined_2 %>% select(all_of(index_features))
full_dataset <- cbind(subject_combined,activity_type,filtered_combined)

## Labelling activity
full_dataset$activity_type <- factor(full_dataset$activity_type, levels = c(1, 2,3, 4,5,6), labels = c("Walking", "Walking Upstairs","Walking Downstairs", "Sitting", "Standing","Laying"))

## Create dataset of averaged values
averaged_data <- full_dataset %>%group_by(activity_type, Subjects) %>% summarise(across("tBodyAcc-mean()-X":"fBodyBodyGyroJerkMag-meanFreq()",mean))


