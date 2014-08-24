# run_analysis.R File Description

This is a documentation for run_analysis.R script, which will perform the following steps on the UCI HAR Dataset downloaded from 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

These are the steps that I follow to get the "tidy_data" set that was required for this project, I labeled them 1 - 12 here and in the "run_analysis.R" file as comments as well.

1. Downloading the **UCI HAR Dataset** data set and puts the zip file working directory. After downloading, it unzips the file into the UCI HAR Dataset folder.
2. Reading the data from UCI HAR Dataset folder, each file in separate data frame
3. Work out how the files fit together by using the dim() function, for example, after deciding that the "x_train" data set and "x_test" data set should be appended together, we can also test that they fit together to make sure we are on the right track by using dim(x_test) and dim(x-train), and clearly we see that they have the same columns number so they must fit together….
4. Merging the x_train and x_test data together using rbind(), then assign a (Descriptive activity names) which is the features names from features.txt to each variable using colnames(). 
5. Merging the subject_train and subject_test data together using rbind(), then assign a (Descriptive activity names) which is the name "subject_id" using colnames.
6. Merging the y_train and y_test data together using rbind(), then assign a (Descriptive activity names) which is the name "activity_id" using colnames().
7. Picking out the mean and standard deviation columns and subsetting to those ones using grep() function.
8. Merging the training and the test sets to create one data set (first data set) using cbind() .
9. Editing the names of the variables using gsub() to get a "Descriptive variable labels".
10. Renaming the activity_type columns names and Merges them with mean_std_data using merge().
11. Producing a tidy data set of the means of the variables for each combination of variable, subject, and activity, using aggregate().
12. Creating a data set as a txt file using write.table().
