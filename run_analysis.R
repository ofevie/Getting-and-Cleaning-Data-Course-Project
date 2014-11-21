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
namecols <- sub("^t","time",namecols)
namecols <- sub("^f","frequency",namecols)

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
# As I see it, the variables are only:
# Some fixed variables or dimensions of the measured variables
# Fixed variables describe the experimental design and are known in advance.
# They somewhat parametrize the results displayed on the measured variables.
# (Please read the paper on tidy data, page 5, just before section 3
# http://vita.had.co.nz/papers/tidy-data.pdf
# Fixed variables:
# 1 - activity
# 2 - subject
# 3 - component - X,Y,Z vector components or Magnitude
# 4 - averagedStatisticalValue - mean or std
# Mesured variables:
# Measured with the Gyroscope:
# 5 - timeBodyAngularVelocity
# 6 - frequencyBodyAngularVelocity
# 7 - timeBodyAngularVelocityJerk (time derivative of BodyAngularVelocity)
# 8 - frequencyBodyAngularVelocityJerk
# Measured with the Accelerometer:
# 9 - timeBodyLinearAcceleration
# 10 - frequencyBodyLinearAcceleration
# 11 - timeBodyLinearAccelerationJerk (time derivative of BodyLinearAcceleration)
# 12 - frequencyBodyLinearAccelerationJerk (time derivative of BodyLinearAcceleration)
# 13 - timeGravityLinearAcceleration



colnames <- c("var","component","averagedStatisticalValue")
tidydata <- meandata %>%
      tidyr::gather(unit_var_comp_stat, val,-one_of("activity","subject")) %>%
      tidyr::separate(unit_var_comp_stat,colnames,sep = "_") %>%
      tidyr::spread(var,val)
rm(colnames)

# To get the result ordered nicely
tidydata$component <- factor(tidydata$component,
                             levels = c("X","Y","Z","Magnitude"))
tidydata$averagedStatisticalValue <- factor(tidydata$averagedStatisticalValue,
                                            levels = c("mean","std"))
# final result:
tidydata <- plyr::arrange(tidydata,activity,subject,component,
                          averagedStatisticalValue)

# write it to file
write.table(tidydata,file = "./tidydata.txt", row.names = FALSE)

# to see this dataset later, use:
# tdata <- read.table("./tidydata.txt", header = TRUE)
# View(tdata)