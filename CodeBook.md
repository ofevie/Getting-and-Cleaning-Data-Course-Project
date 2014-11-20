# Code Book
Ofelia  
### Introduction

This file, together with README.md and run_analysis.R are the result of a Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The work is peer-reviewed.

This document is part of a set of documents:

* CodeBook.md
* README.md
* run_analysis.R
* tidydata.txt

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
<https://class.coursera.org/getdata-009/forum/thread?thread_id=58>, 'Do we need the inertial folder'. These folders contain the raw data used to obtain the results in X\_train.txt and X\_test.txt.

### The data
The data was collected from the accelerometers from the Samsung Galaxy S II smartphone. The experiments consisted on the measurements of activities (laying, sitting, walking, etc) of 30 volunteers wearing a smartphone on the waist. Using the smartphones' embedded accelerometer and gyroscope, the 3-axial linear acceleration and 3-axial angular velocity was captured at a constant rate of 50Hz (in the time domain). The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The data was pre-processed by the application of noise filters, and some data was deduced (Gravity data) from the accelerometer signal. A Fast-Fourier-Transform (FFT) was applied to the data as well, giving some signals in the frequency domain. 
For more details, please look at the README.txt and features_info.txt files of the dataset.

## Work performed to clean the data

### Instructions of the assignment
"You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

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

Using the above interpretation, the training and test sets are merged using rbind() into the following variables:

- *Xdata* is the merge of *X\_train* with *X\_test*;
- *activity* is the merge of *y\_train* and *y\_test*;
- *subject* is the merge of *subject\_train* and *subject\_test*.

### Extract only the measurements of the mean and standard deviation

Here the instructions leave room for some interpretation. 

If one searches for the word "mean" among the column names, the result shows variables that are marked as a mean value was calculated ("-mean()") but also variables that were calculated using the meanFrequency ("meanFreq()").
In the "features\_info.txt" file it is explained that the mean (mean()) and standard deviation (std()) (among other estimations) are calculated from the following 33 signals:
tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag and fBodyGyroJerkMag.
This is the interpretation taken in this work. Only variables that have "-mean()" and "-std()" present in their name are going to be filtered.
As a result, 66 variables remain.

### Use descriptive activity names to name the activities in the data set

Right now the variable *activity* is coded with values from 1 to 6. The decoding variable is *activity_labels*.
For this part of the assignment, I simply set the names present in *activity_labels* to lower case and used them as they are. After exchanging the numbers by the corresponding labels, the variable *activity* was set to be of type factor with the levels ordered in increasing expected amount of movement (laying, sitting, standing, walking, walking\_downstairs and walking\_upstairs).

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

### Creating a tidy dataset from the data

The actual instructions are: from the output data of the previous steps, create a second, independent tidy data set with the average of each variable for each activity and each subject.

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

(The original data violated the 3rd characteristic: we needed to use several files to construct a complete dataset/observational unit.)

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

- observationDoman\_MeasuredVariable\_component\_averagedStatisticalValue

Using this fact, it is relatively easy to use the tidyr package tooling to gather, separate and spread *meandata* to obtain *tidydata*.

*tidydata* has 2880 observations of 10 variables.

#### NA values

The variables frequency\_GravityLinearAcceleration\_(any component)\_(any averagedStatisticalValue) and , frequency\_BodyAngularVelocityJerk\_(XYZ)_(any averagedStatisticalValue) do not exist. This means that in the tidy dataset NA values are introduced.

## Output variables description

Variables of **tidydata.txt**.

**activity**

- Description: physical activity realized by the volunteers. 
- Type: factor, 6 levels.

1. "laying"
2. "sitting"
3. "standing"
4. "walking"
5. "walking_downstairs"
6. "walking_upstairs"


**subject**

- Description: identification code for each volunteer.
- Type: factor, 30 levels, ordered numerically from 1 to 30.

1. "1"
2. "2"
3. "3" ...
      

**observationDomain**

- Description: indicates if the measured variables are in the time  domain or in the frequency domain. The frequency domain variables were obtained using a Fast-Fourier-Transform on the time domain variables.
- Type: factor, 2 levels.

1. "time"
2. "frequency"


**component**

- Description: indicates the vectorial axis component or the Magnitude of the measured variables.
- Type: factor, 4 levels.

1. "X"
2. "Y"
3. "Z"
4. "Magnitude"


**averagedStatisticalValue**

- Description: Indicates which statistical value of the measured variables was averaged. "std" stands for "standard deviation".
- Type: factor, 2 levels.

1. "mean"
2. "std"

**bodyAngularAcceleration**

- Description: observed variable, measured by the Gyroscope.
- Type: numeric (double).

**bodyAngularAccelerationJerk**

- Description: observed variable, measured by the Gyroscope.
- Type: numeric (double).

**bodyLinearAcceleration**

- Description: observed variable, measured by the Accelerometer.
- Type: numeric (double).

**bodyLinearAccelerationJerk**

- Description: observed variable, measured by the Accelerometer.
- Type: numeric (double).

**gravityLinearAcceleration**

- Description: observed variable, measured by the Accelerometer.
- Type: numeric (double).


