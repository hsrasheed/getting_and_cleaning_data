# Codebook

## Data Set

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

## Tranformations

* Find all of the desired features (those with mean and std in the label)
* Get a dataframe with only those variables
* Remove unwanted characters "(",")" from variable names
* Load the training and test files, selecting only the columns with the desired measurements
* Join the three training data sets (features, activity and subject) together to make one training set
* Join the three test data sets (features, activity and subject) together to make one training set
* Join the test and training set together
* Convert the activity labels to their class names as found in the "activity_labels.txt" file
* Melting the measurements to a single column with id being the subject and the activity
* Aggregating the measurements per subject, per activity and taking the mean
