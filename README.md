# RLearning_assignment
This Repo contains the script for cleaning the Samsung health data as per the assignment request. 

THe package dplyr is required. 

This script loads the following files, merges them into a single dataset, 
then extacts the mean and SD for each of the measurements: 
 - test/X_test.txt
 - train/X_train.txt
Initially the raw data, row names, and column names are added, thereafter the subject's number is included

The file is then filtered for just the mean and std columns
The two files are then merged, and the activities renamed for easy of reading 

A final dataset is created, with the averages for the activity per individual. 

