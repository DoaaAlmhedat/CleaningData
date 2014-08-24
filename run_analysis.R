# run_analysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity
#    and each subject. 

# ----------------------------------------------------------------------------------------------
# 1.Download the data from the website to the working directory
# ----------------------------------------------------------------------------------------------

library(RCurl)

if (!file.info("UCI HAR Dataset")$isdir) {
  dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dir.create("UCI HAR Dataset")
  download.file(dataFile, "UCI-HAR-dataset.zip", method="curl")
  unzip("./UCI-HAR-dataset.zip")
}

# ----------------------------------------------------------------------------------------------
# 2.Reading the data each file in seprate data frame
# ----------------------------------------------------------------------------------------------

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt") #imports x_train.txt
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt") #imports x_test.txt


subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") #imports subject_train.txt
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") #imports subject_test.txt


y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") #imports x_train.txt
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") #imports x_test.txt


features <- read.table("./UCI HAR Dataset/features.txt") #imports features.txt

activity_type <- read.table("./UCI HAR Dataset/activity_labels.txt") #imports activity_labels.txt
# ----------------------------------------------------------------------------------------------
# 3.Work out how the files fit together
# ----------------------------------------------------------------------------------------------

dim(x_train)    # [1] 7352  561  
dim(x_test)     # [1] 2947  561

dim(subject_train) # [1] 7352    1
dim(subject_test)  # [1] 2947    1

dim(y_train)    # [1] 7352    1
dim(y_test)     # [1] 2947    1

dim(features)   # [1] 561   2

dim(activity_type) # [1] 6 2

# ----------------------------------------------------------------------------------------------
# 4. Merges the x_train and x_test data together using rbind()
# then assign a (Descriptive activity names) 
# which is the features names from features.txt to each variable using colnames 
# ----------------------------------------------------------------------------------------------

x <- rbind(x_train, x_test)
colnames(x) <- features[,2]

# ----------------------------------------------------------------------------------------------
# 5. Merges the subject_train and subject_test data together using rbind()
# then assign a (Descriptive activity names) which is the name "subject_id" using colnames 
# ----------------------------------------------------------------------------------------------

subject <- rbind(subject_train, subject_test)
colnames(subject) <- "subject_id"

# ----------------------------------------------------------------------------------------------
# 6. Merges the y_train and y_test data together using rbind()
# then assign a (Descriptive activity names) which is the name "activity_id" using colnames 
# ----------------------------------------------------------------------------------------------

y <- rbind(y_train, y_test)
colnames(y) <- "activity_id"


# ----------------------------------------------------------------------------------------------
# 7. Picking out the mean and standard deviation columns and subsetting to those ones
# ----------------------------------------------------------------------------------------------

mean_std_columns <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x <- x[ ,mean_std_columns] 

# ----------------------------------------------------------------------------------------------
# 8. Merges the training and the test sets to create one data set (first data set) using cbind() 
# ----------------------------------------------------------------------------------------------

mean_std_data <- cbind(x, subject, y)

# ----------------------------------------------------------------------------------------------
# 9. Descriptive variable labels
# ----------------------------------------------------------------------------------------------
temp_colnames <- colnames(mean_std_data) # to include the new column names after merge


# Cleaning up the variable names
for (i in 1:length(temp_colnames)) 
{
  temp_colnames[i] <- gsub("\\()","",temp_colnames[i])
  temp_colnames[i] <- gsub("-std$","StdDev",temp_colnames[i])
  temp_colnames[i] <- gsub("-mean","Mean",temp_colnames[i])
  temp_colnames[i] <- gsub("^(t)","time",temp_colnames[i])
  temp_colnames[i] <- gsub("^(f)","freq",temp_colnames[i])
  temp_colnames[i] <- gsub("([Gg]ravity)","Gravity",temp_colnames[i])
  temp_colnames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",temp_colnames[i])
  temp_colnames[i] <- gsub("[Gg]yro","Gyro",temp_colnames[i])
  temp_colnames[i] <- gsub("AccMag","AccMagnitude",temp_colnames[i])
  temp_colnames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",temp_colnames[i])
  temp_colnames[i] <- gsub("JerkMag","JerkMagnitude",temp_colnames[i])
  temp_colnames[i] <- gsub("GyroMag","GyroMagnitude",temp_colnames[i])
}

colnames(mean_std_data) <- temp_colnames

# ----------------------------------------------------------------------------------------------
# 10. Rename the activity_type columns names and Merges them with mean_std_data using merge() 
# ----------------------------------------------------------------------------------------------

colnames(activity_type) <- c("activity_id","activity_type")
final_data <- merge(mean_std_data, activity_type, by= "activity_id", all.x = T)

# ----------------------------------------------------------------------------------------------
# 11. produce a tidy data set of the means of the variables for each combination of variable,
# subject, and activity.
# ----------------------------------------------------------------------------------------------

# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType <- final_data[,names(final_data) != "activity_type"]

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity
# and each subject
tidy_data <- aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c("activity_id","subject_id")],
                         by=list(activity_id=finalDataNoActivityType$activity_id,
                         subject_id = finalDataNoActivityType$subject_id),mean)

# Merging the tidyData with activityType to include descriptive acitvity names
tidy_data <- merge(tidy_data,activity_type,by="activity_id",all.x=TRUE)

# ----------------------------------------------------------------------------------------------
# 12. creat a data set as a txt file using write.table() 
# ----------------------------------------------------------------------------------------------
write.table(tidy_data, "./tidy_data.txt", row.name = FALSE, sep="\t")


