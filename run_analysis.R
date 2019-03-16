## File Name: 		run_analysis.R
## Author:			Hassan Rasheed
## Date:			3/15/2019
## Description:		This file performs the following main tasks:
##    					1. Merges the training and the test sets to create one data set.
##    					2. Extracts only the measurements on the mean and standard deviation for each measurement.
##    					3. Uses descriptive activity names to name the activities in the data set
##    					4. Appropriately labels the data set with descriptive variable names.
##    					5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)

# This file is intended to be run in the folder just above the "UCI HAR Dataset" folder that contains the test and training directory and metadata files.

# Read metadata files
df_activities = read.table("UCI HAR Dataset\\activity_labels.txt",sep="",header=FALSE)
names(df_activities) <- c("label","activity_name")
df_features= read.table("UCI HAR Dataset\\features.txt",sep="",header=FALSE)
names(df_features) <- c("feature_number","feature_name")

# Find all of the desired features (those with mean and std in the label)
desired_feature_num <- grep("(mean|std)\\(\\)",df_features[,"feature_name"])
# Get a dataframe with only those variables
desired_measurements <- df_features[desired_feature_num,"feature_name"]

# Remove unwanted characters from variable names
desired_measurements <- gsub("[()]","",desired_measurements)

# load the training and test files, selecting only the columns with the desired measurements
# x = measurements, y = activity
df_X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt",sep="",header=FALSE,col.names=df_features[["feature_name"]])[ , desired_feature_num]
df_Y_train <- read.table("UCI HAR Dataset\\train\\Y_train.txt",sep="",header=FALSE,col.names=c("activity"))
df_subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt",sep="",header=FALSE,col.names=c("subject_num"))
df_X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt",sep="",header=FALSE,col.names=df_features[["feature_name"]])[ , desired_feature_num]
df_Y_test <- read.table("UCI HAR Dataset\\test\\Y_test.txt",sep="",header=FALSE,col.names=c("activity"))
df_subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt",sep="",header=FALSE,col.names=c("subject_num"))

# Join the three data sets together to make one training set
df_train_X_Y <- cbind(df_X_train,df_Y_train,df_subject_train)

# Join the three data sets together to make one test set
df_test_X_Y <- cbind(df_X_test,df_Y_test,df_subject_test)

# Join the test and training set together
df_test_train <- rbind(df_train_X_Y,df_test_X_Y)

# convert the activity labels to their class names
df_test_train[["activity"]] <- factor(df_test_train[, "activity"], levels = df_activities[["label"]], labels = df_activities[["activity_name"]])

# convert the subject_num to a factor
df_test_train[["subject_num"]] <- as.factor(df_test_train[,"subject_num"])

# The melt function takes data in wide format and stacks a set of columns into a single column of data. 
# To make use of the function we need to specify a data frame, the id variables (which will be left at their settings) and the measured variables (columns of data) to be stacked.
tidy_df <- melt(df_test_train, id= c("subject_num","activity"))

# use the dcast function to aggregate the variables that we melted together using the mean function
tidy_df <- dcast(data = tidy_df, subject_num + activity ~ variable, fun.aggregate=mean)

# Write the tidy data out to a file
write.table(tidy_df,"accelerometer_tidy_data.txt",row.names=FALSE)
