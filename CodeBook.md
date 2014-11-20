# Code Book - Course Project - Getting and Cleaning Data
Ofelia  
### Introduction

This file, together with README.md and run_analysis.R are the result of a Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The work is peer-reviewed.

This document is part of a set of documents:

* CodeBook.md - This file.
* README.md - A detailed explanation about the project and the R script.
* run_analysis.R - The R script code.
* tidydata.txt - The output of the R script.

### Output variables description

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


