# README
Ofelia  
## Project Description


This file, together with CodeBook.md and run_analysis.R are the result of a Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The work is peer-reviewed.

This document is part of a set of documents:

* CodeBook.md
* README.md
* run_analysis.R
* tidydata.txt

## Origin of the data

The idea of the assignment is that we download data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. More information about the data and its original project can be obtained from: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.  
The downloaded data is in a somewhat messy form. The goal of the project is to understand what the data is about, work with it, filter the results we are interested in, and finally create a tidy dataset from the messy data.  
The guidelines for 'what is tidy data' are taken from the publication 'Tidy data' by Hadley Wickham (<http://vita.had.co.nz/papers/tidy-data.pdf>).

A detailed description on the downloaded files and data is present in CodeBook.md.

## The *run_analysis.R* script

### Introduction

"Happy families are all alike; every  
unhappy family is unhappy in its own  
way"  
Leo Tolstoy

I decided to imitate Mr. Hadley Wickham and also add this little phrase. Also, in Wickham's words:  

"Like families, tidy datasets are all alike but every messy dataset is messy in its own way."  

What does this imply?  
This means that the content of this project is not easily transferable to another project. As each messy data is messy in its own way, each different type of messy data needs to be tackled differently. However, there are some "lessons learned" from the project:

- using the reshape2 package for melting and casting;
- using a variable name convention that allows easier understanding of the data;
- using the plyr and tidyr packages to arrange and tidy the data to its final form.

### Assumptions

R version 3.1.1 (2014-07-10) "Sock it to Me" on platform x86_64-apple-darwin13.1.0.

#### About the data files

*run_analysis.R* assumes that the data was downloaded and the files are in the current working directory of R. For a more detailed explanation of which files were used, please look at the CodeBook.md file.

#### About the R packages
I use a number of packages outside the standard installation:

- reshape2
- plyr
- tidyr

These packages must be installed before running the script.

### Output

The output of *run_analysis.R* is tidy data as a space-separated table in text format called "tidydata.txt". The tidy data consists of 10 columns and 2880 observations. Some NA values were introduced.  
The program will write the tidy data to the current working directory.
To see the tidy data, please run:

```
tdata <- read.table("./tidydata.txt", header = TRUE)
View(tdata)
```

### The project instructions

"You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

### The script code

As there is a very detailed explanation of the work in CodeBook.md, here I limit myself to just put the code in its 'raw form'.

```
## Instructions
## You should create one R script called run_analysis.R that does the 
## following:
## 1 - Merges the training and the test sets to create one data set.
## 2 - Extracts only the measurements on the mean and standard deviation 
##     for each measurement.
## 3 - Uses descriptive activity names to name the activities in the data set.
## 4 - Appropriately labels the data set with descriptive variable names.
## 5 - From the data set in step 4, creates a second, independent tidy data set
##     with the average of each variable for each activity and each subject.


# Open files and load data into variables

var_names <- c("features","activity_labels","subject_train","X_train","y_train",
               "subject_test","y_test","X_test")

if (!all(var_names %in% ls(.GlobalEnv))) {
      
      features <- read.table("./features.txt", header = FALSE, 
                             stringsAsFactors = FALSE)
      
      activity_labels <- read.table("./activity_labels.txt", header = FALSE, 
                                    stringsAsFactors = FALSE,
                                    colClasses = "character")

      subject_train <- read.table("./train/subject_train.txt", header = FALSE, 
                                  stringsAsFactors = FALSE)
      
      X_train <- read.table("./train/X_train.txt", header = FALSE, 
                            stringsAsFactors = FALSE)
      
      y_train <- read.table("./train/y_train.txt", header = FALSE, 
                            stringsAsFactors = FALSE)
      
      subject_test <- read.table("./test/subject_test.txt", header = FALSE, 
                                 stringsAsFactors = FALSE)
      
      y_test <- read.table("./test/y_test.txt", header = FALSE, 
                           stringsAsFactors = FALSE)
      
      X_test <- read.table("./test/X_test.txt", header = FALSE, 
                           stringsAsFactors = FALSE)
}
rm(var_names)

### 1 - Merging the training and the test sets to create one data set.
# 
# To do this, we must understand what the variables are:
# - X_test (nrows = 2947, ncols = 561) and X_train (nrows = 7352, ncols = 561) are   
#   "the data sets".
# - features (nrows = 561, ncols = 2)  names the columns of X_test and X_train
#   1st col is an index (1 to 561)
#   2nd col are the names
# - activity_labels (nrows = 6, ncols = 2) assigns a code [1-6] to each activity
#   type
# - y_test (nrows = 2947, ncol = 1) labels the rows of X_test per activty type 
#   taking values of [1-6]. Decoded with activity_labels. 
#   Same applies to y_train - X_train
# - subject_test (nrows = 2947, ncols = 1) labels the rows of X_test per 
#   subject/volunteer, same applies to subject_train - X_train

# To merge both datasets, as they scope the same 561 columns, 
# must use rbind 
Xdata <- rbind(X_train,X_test)
activity <- rbind(y_train,y_test)
subject  <- rbind(subject_train,subject_test)

## 2 - Extracting only the measurements on the mean and standard deviation 
##     for each measurement.

# Here it is a bit open to interpretation:
# shall we include for example "angle(Z,gravityMean)" or 
# "fBodyAcc-meanFreq()-X"?
# I choose to interpret that it should be the name of the variable "tBodyAcc",
# "tGravityAcc", etc. followed by either "-mean()" or "-std()" and the axis 
# name: X, Y or Z
# This means that variables as: "angle(Z,gravityMean)" and 
# "fBodyAcc-meanFreq()-X" are not included

cond1 <- grepl("mean(", features[[2]], fixed = TRUE)
cond2 <- grepl("std", features[[2]], fixed = TRUE)
cond <- cond1 | cond2
data <- Xdata[,cond]
namecols  <- features[cond,2]

rm(cond1,cond2,cond)

## 3 - Uses descriptive activity names to name the activities in the data set.
# The descriptions are in variable activity_labels, the activities per row are
# in the variable activity
# I personally don't like the uppercases

activity_labels$V2 <- tolower(activity_labels$V2)

for (i in 1:6L) {
      activity$V1[activity$V1 == activity_labels$V1[i]] <- activity_labels$V2[i]
}

# I chose the level order in an expected increasing activity level
levels = c("laying","sitting","standing","walking","walking_downstairs",
           "walking_upstairs")
activity$V1 <- factor(activity$V1,levels = levels)
rm(levels)


## 4 - Appropriately label the data set with descriptive variable names.
# the names of the columns in Xdata are in the variable namecols

#remove the 'BodyBody' mistake
namecols <- sub("BodyBody","Body",namecols) 

temp <- grepl("-mean()", namecols, fixed = TRUE)
namecols[temp] <- paste(namecols[temp],"mean", sep = "_")
namecols <- sub("-mean()","",namecols, fixed = TRUE)

temp <- grepl("-std()", namecols, fixed = TRUE)
namecols[temp] <- paste(namecols[temp],"std", sep = "_")
namecols <- sub("-std()","",namecols, fixed = TRUE)

namecols <- sub("-X","_X",namecols, fixed = TRUE)
namecols <- sub("-Y","_Y",namecols, fixed = TRUE)
namecols <- sub("-Z","_Z",namecols, fixed = TRUE) 
namecols <- sub("Mag","_Magnitude",namecols, fixed = TRUE)

# Make variable names more descriptive
namecols <- sub("Acc","LinearAcceleration",namecols, fixed = TRUE)
namecols <- sub("Gyro","AngularVelocity",namecols, fixed = TRUE)
namecols <- sub("^t","time_",namecols)
namecols <- sub("^f","frequency_",namecols)


names(data) <- namecols
rm(namecols, temp)
names(activity) <- "activity"
subject$V1 <- factor(subject$V1)
names(subject) <- "subject"

# So, the complete (and ordered) dataset (but not tidy)
data <- cbind(activity,subject,data)
data <- plyr::arrange(data,activity,subject)

## 5 - From the data set in step 4, creates a second, independent tidy data set
##     with the average of each variable for each activity and each subject.

dataMelt <- reshape2::melt(data,id=c("activity","subject"))
meandata <- reshape2::dcast(dataMelt,activity+subject~variable,mean)
rm(dataMelt)

# Right now we have the mean value of the original columns per activity 
# and subject. We have to make the dataset tidy.

# Characteristics of a tidy dataset:
# Each variable forms a column
# Each observation forms a row
# Each type of observational unit forms a table

# The key part here is to define 'what is a variable?'
# As I see it, the variables are only 10:
# Some fixed variables or dimensions of the measured variables
# Fixed variables describe the experimental design and are known in advance.
# They somewhat parametrize the results displayed on the measured variables.
# (Please read the paper on tidy data, page 5, just before section 3
# http://vita.had.co.nz/papers/tidy-data.pdf
# Fixed variables:
# 1 - activity
# 2 - subject
# 3 - observationDomain - time or frequency
# 4 - component - X,Y,Z vector components or Magnitude
# 5 - averagedStatisticalValue - mean or std
# Mesured variables:
# Measured with the Gyroscope:
# 6 - BodyAngularVelocity
# 7 - BodyAngularVelocityJerk (time derivative of BodyAngularVelocity)
# Measured with the Accelerometer:
# 8 - BodyLinearAcceleration
# 9 - BodyLinearAccelerationJerk (time derivative of BodyLinearAcceleration)
# 10 - GravityLinearAcceleration


colnames <- c("observationDomain","var","component",
              "averagedStatisticalValue")
tidydata <- meandata %>%
      tidyr::gather(unit_var_comp_stat, val,-one_of("activity","subject")) %>%
      tidyr::separate(unit_var_comp_stat,colnames,sep = "_") %>%
      tidyr::spread(var,val)
rm(colnames)

# To get the result ordered nicely
tidydata$observationDomain <- factor(tidydata$observationDomain,
                                     levels = c("time", "frequency"))
tidydata$component <- factor(tidydata$component,
                             levels = c("X","Y","Z","Magnitude"))
tidydata$averagedStatisticalValue <- factor(tidydata$averagedStatisticalValue,
                                            levels = c("mean","std"))
# final result:
tidydata <- plyr::arrange(tidydata,activity,subject,observationDomain,
                          component,averagedStatisticalValue)

# For consistency in the naming:
nmcols <- names(tidydata)
nmcols <- sub("Body","body",nmcols)
nmcols <- sub("Gravity","gravity",nmcols)
names(tidydata) <- nmcols
rm(nmcols)

# write it to file
write.table(tidydata,file = "./tidydata.txt", row.names = FALSE)

# to see this dataset later, use:
# tdata <- read.table("./tidydata.txt", header = TRUE)
# View(tdata)

```

