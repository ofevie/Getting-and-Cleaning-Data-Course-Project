# ReadMe - Course Project - Getting and Cleaning Data
Ofelia  
# Project Description

This file, together with CodeBook.md and run_analysis.R are the result of a Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The work is peer-reviewed.

This document is part of a set of documents:

* CodeBook.md - Lists the variables in "tidydata.txt".
* README.md - This file.
* run_analysis.R - The R script code.
* tidydata.txt - The output of the R script.

# Origin of the data

The idea of the assignment is that we download data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. More information about the data and its original project can be obtained from: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.  
The downloaded data is in a somewhat messy form. The goal of the project is to understand what the data is about, work with it, filter the results we are interested in, and finally create a tidy dataset from the messy data.  
The guidelines for 'what is tidy data' are taken from the publication 'Tidy data' by Hadley Wickham (<http://vita.had.co.nz/papers/tidy-data.pdf>).

## Input Data

### The files
The input data was downloaded from the link:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
as a 'zip' file. Within this zip file there are the following documents and directories:

* README.txt
* features_info.txt
* features.txt
* activity_levels.txt
* _test_ and _train_ directories

To run the R script 'run_analysis.R' it is assumed the user has all these files and directories in the working directory, unzipped.

Inside both _test_ and _train_ there are a number of files (only for the _test_ directory):

* X_test.txt
* y_test.txt
* subject_test.txt
* _Inertial Signals_ directory

Similar files, but now with the suffix 'train' can be found in the _train_ directory.

In this project, the files contained in the _Inertial Signals_ directories are not going to be used, as explained in
<https://class.coursera.org/getdata-009/forum/thread?thread_id=58>, 'Do we need the inertial folder'. These folders contain the raw data used to obtain the results in X\_train.txt and X\_test.txt and they are of no interest for this particular project.

### The details about the data

The data was collected from the accelerometers from the Samsung Galaxy S II smartphone. The experiments consisted on the measurements of activities (laying, sitting, walking, etc) of 30 volunteers wearing a smartphone on the waist. Using the smartphones' embedded accelerometer and gyroscope, the 3-axial linear acceleration and 3-axial angular velocity was captured at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.   
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity (tBodyAcc-XYZ and tGravityAcc-XYZ). The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.  
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).  
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag and fBodyGyroJerkMag
('-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.)

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable: gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean and tBodyGyroJerkMean.

Note:

- Features are normalized and bounded within [-1,1].

(The information stated here comes from the files README.txt and features_info.txt that came with the original data.)


# The *run_analysis.R* script

## Introduction

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

## Assumptions

The R script runs fine in my R version: R version 3.1.1 (2014-07-10) "Sock it to Me" on platform x86_64-apple-darwin13.1.0.

### About the data files

*run_analysis.R* assumes that the data was downloaded and the files are in the current working directory of R.

### About the R packages
I use a number of packages outside the standard installation:

- reshape2
- plyr
- tidyr

These packages must be installed before running the script.

## The project instructions

"You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

## Work performed to clean the data

### Load data into R data frames

The data is loaded into R data frames that have the same names as the original files:

- *features*, *activity\_labels*
- *X\_test*, *y\_test*, *subject\_test*
- *X\_train*, *y\_train*, *subject\_train*

### Interpretation of the data frames and merging

- *X\_test* (nrows = 2947, ncols = 561) and *X\_train* (nrows = 7352, ncols = 561) are "the data sets". 
- *features* (nrows = 561, ncols = 2)  names the variables/columns of *X\_test* and *X\_train*. *features* 1st column is an index (1 to 561), and its 2nd column contains the names of the variables.
- *activity_labels* (nrows = 6, ncols = 2) assigns a code (1 to 6) to each activity type. The 1st column is the code (1 to 6), the 2nd column is the activity (walking, sitting, etc).
- *y\_test* (nrows = 2947, ncols = 1) labels the rows of *X\_test* per activity type taking values of (1 to 6). Decoded with *activity\_labels*. Same applies to the relation *y\_train* - *X\_train*.
- *subject\_test* (nrows = 2947, ncols = 1) labels the rows of *X\_test* per subject/volunteer, and the same applies to the relation *subject\_train* - *X\_train*.

![alt text](https://coursera-forum-screenshots.s3.amazonaws.com/ab/a2776024af11e4a69d5576f8bc8459/Slide2.png)

(Picture is from <https://class.coursera.org/getdata-009/forum/thread?thread_id=58>.)

Using the above interpretation, the training and test sets are merged using `rbind()` into the following variables:

- *Xdata* is the merge of *X\_train* with *X\_test*;
- *activity* is the merge of *y\_train* and *y\_test*;
- *subject* is the merge of *subject\_train* and *subject\_test*.

```
Xdata <- rbind(X_train,X_test)
activity <- rbind(y_train,y_test)
subject  <- rbind(subject_train,subject_test)
```


### Extract only the measurements of the mean and standard deviation

Here the instructions leave room for some interpretation. 

If one searches for the word "mean" among the column names, the result shows variables that are marked as a mean value was calculated ("-mean()") but also variables that were calculated using the meanFrequency ("meanFreq()"), because both names have the word "mean" in them.

In the "features\_info.txt" file it is explained that the mean (mean()) and standard deviation (std()) (among other estimations) are calculated from the following 33 signals:
tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag and fBodyGyroJerkMag.
Also it is explained that the "meanFreq()" is the weighted average of the frequency components to obtain a mean frequency, and this is used as input on other variables. It makes no mathematical sense to take an average of these functions.
In the interpretation taken in this work, **only variables that have "-mean()" and "-std()" present in their name are going to be filtered out**.
As a result, 66 variables remain.

```
cond1 <- grepl("mean(", features[[2]], fixed = TRUE)
cond2 <- grepl("std", features[[2]], fixed = TRUE)
cond <- cond1 | cond2
data <- Xdata[,cond]
namecols  <- features[cond,2]
```

### Use descriptive activity names to name the activities in the data set

Right now the variable *activity* is coded with values from 1 to 6. The decoding variable is *activity_labels*.
For this part of the assignment, I simply set the names present in *activity_labels* to lower case and used them as they are. After exchanging the numbers by the corresponding labels, the variable *activity* was set to be of type factor with the levels ordered in increasing expected amount of movement (laying, sitting, standing, walking, walking\_downstairs and walking\_upstairs).

```
activity_labels$V2 <- tolower(activity_labels$V2)
for (i in 1:6L) {
      activity$V1[activity$V1 == activity_labels$V1[i]] <- activity_labels$V2[i]
}
levels = c("laying","sitting","standing","walking","walking_downstairs",
           "walking_upstairs")
activity$V1 <- factor(activity$V1,levels = levels)
```

### Label the data set with descriptive variable names

In a few of the variable names, a mistake done by the authors was discovered: the word "Body" was doubled for some of the variables (fBodyBodyAccJerkMag-mean(), fBodyBodyGyroJerkMag-mean(), etc). The first step was to correct this mistake.    
The implemented name changes were as follows:

- The characters "-X", "-Y", "-Z" were substituted by "\_X", "\_Y" and "\_Z" respectively, in the appropriate variables.
- "Mag" was substituted by "_Magnitude" in the appropriate variables.
- "Acc" was substituted by "LinearAcceleration" in the appropriate variables.
- "Gyro" was substituted by "AngularVelocity" in the appropriate variables.
- "t" was substituted by "time_" in the appropriate variables.
- "f" was substituted by "frequency_" in the appropriate variables.
- For the variables containing "-mean()" a suffix "_mean" was added to the variable name, and the "-mean()" was removed.
- For the variables containing "-std()" a suffix "_std" was added to the variable name, and the "-std()" was removed.

Then, the original variable "tBodyAcc-mean()-X" transforms into "time\_BodyLinearAcceleration\_X\_mean".

The variable names became very long (but much clearer) with this format.

```
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

namecols <- sub("Acc","LinearAcceleration",namecols, fixed = TRUE)
namecols <- sub("Gyro","AngularVelocity",namecols, fixed = TRUE)
namecols <- sub("^t","time_",namecols)
namecols <- sub("^f","frequency_",namecols)

names(data) <- namecols
```

#### The complete (messy) data

Finally, the activities and subject are added to the data. The data is then ordered by activity and subject.

```
names(activity) <- "activity"
subject$V1 <- factor(subject$V1)
names(subject) <- "subject"

data <- cbind(activity,subject,data)
data <- plyr::arrange(data,activity,subject)
```

### Creating a tidy dataset from the data

The actual instructions are: "from the output data of the previous steps, create a second, independent tidy data set with the average of each variable for each activity and each subject."

This step is actually divided into 2 steps:

1. Get the average of each variable for each activity and each subject.
2. With the resulting dataset, create a tidy dataset.


#### Get the average of each variable for each activity and each subject

This is achieved by "melting" and "casting" the data. The variable *meandata* is created.
```
dataMelt <- reshape2::melt(data,id=c("activity","subject"))
meandata <- reshape2::dcast(dataMelt,activity+subject~variable,mean)
```
*meandata* has 180 (6 activities x 30 subjects) observations of 68 variables.

#### Using *meandata*, create a tidy dataset

Right now we have the mean value of the original columns per activity and subject. We have to make the dataset tidy.

Characteristics of a tidy dataset:

- Each variable forms a column.
- Each observation forms a row.
- Each type of observational unit forms a table.

(The original data clearly violated the 3rd characteristic: we needed to use several files to construct a complete dataset/observational unit.)

In the case of *meandata* the key part is to answer: **'what is a variable?'**.
As I see it, the variables are only 10:

- 5 fixed variables
- 5 observational variables

Fixed variables describe the experimental design and are known in advance.
They somewhat parameterize the results displayed on the measured variables.
(Please read the paper on tidy data, page 5, just before section 3
<http://vita.had.co.nz/papers/tidy-data.pdf>).

The fixed variables are:

1. activity
2. subject
3. **observationDomain** - time or frequency
4. **component** - X,Y,Z vector component or Magnitude
5. **averagedStatisticalValue** - mean or std

The 5 **measured variables** are:

Measured with the Gyroscope:

6. BodyAngularVelocity
7. BodyAngularVelocityJerk (time derivative of BodyAngularVelocity)

Measured with the Accelerometer:

8. BodyLinearAcceleration
9. BodyLinearAccelerationJerk (time derivative of BodyLinearAcceleration)
10. GravityLinearAcceleration

The way the variables were named in the step 4 comes into play.
All variable names follow this convention:

- observationDomain\_MeasuredVariable\_component\_averagedStatisticalValue

Using this fact, it is relatively easy to use the tidyr package tooling to gather, separate and spread *meandata* to obtain *tidydata*.

*tidydata* has 2880 observations of 10 variables.


```
colnames <- c("observationDomain","var","component",
              "averagedStatisticalValue")
tidydata <- meandata %>%
      tidyr::gather(unit_var_comp_stat, val,-one_of("activity","subject")) %>%
      tidyr::separate(unit_var_comp_stat,colnames,sep = "_") %>%
      tidyr::spread(var,val)
```
#### Disgression about tidy data

As it is mentioned in the thread of this subject ['Tidy data and the assignment'](https://class.coursera.org/getdata-009/forum/thread?thread_id=192), the form of the tidy data will depend greatly on the use we want of the data.  
My approach was from the angle of physics (my subject area) and mostly with the idea of easier subsetting, as I don't know the application of the data. As a physisist, I personally would like to separate time domain observations from frequency domain ones (they are related, but have very different applications), as well as vectorial components (x-, y-, z- directions) from the magnitude of the vector (a scalar). And of course the mean and standard deviation are totally different quantities.
I could have continued the separation: accelerometer vs. gyroscope, non-jerk vs. jerk signals. As only 5 columns/variables remain, my thought was that if I wanted to subset those columns only, I would just type the names of the variables.

#### NA values

The variables frequency\_GravityLinearAcceleration\_(any component)\_(any averagedStatisticalValue) and , frequency\_BodyAngularVelocityJerk\_(XYZ)_(any averagedStatisticalValue) do not exist. This means that in the tidy dataset NA values are introduced.

## Output

The output of *run_analysis.R* is tidy data as a space-separated table in text format called "tidydata.txt". The tidy data consists of 10 columns and 2880 observations. Some NA values were introduced.  
The program will write the tidy data to the current working directory.
To see the tidy data, please run:

```
tdata <- read.table("./tidydata.txt", header = TRUE)
View(tdata)
```
Please look at the file CodeBook.md for a clarification of each variable.

## The script code


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

