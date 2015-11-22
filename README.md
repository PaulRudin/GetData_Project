# Getting and Cleaning Data - Course Project

This file describes the code in run_analysis.R. See CodeBook.md for more on the data itself.

The structure of the code is as follows.

## utilities

data_dir gives the relative location of the directory containing the data. If
the supplied zip file is unzipped in the current directory nothing needs
changing.



## merged_data

This function implements the first step of the project - the data from the
training and test data sets are loaded into a data table. No metadata about the
source of each observation is retaining as this is not needed for the remainder
of the project.

Additional columns for the activities and subject of each observation are added
to the data table

## extract_features

The removes columns from the supplied dataset that do not include the strings
"std" or "mean", the rubric is slightly unclear about exactly which variables
should be retained.

## rename_activities

This replaces the activities column values with a factor containing more
descriptive activity names as supplied with the original data.

## rename_variables

This gives the variables more meaningful columns headings - see the file
features.txt for the names and the file features_info.txt for information about
the meaning of each feature.

## do_steps

This performs all the steps described above to create a new data table from the
data on disk.

## averages

Creates a new data table that averages each variable by subject and
activity. Since there are 30 subjects and 6 activities we get a total of 180
rows.

## write_td

Creates the tiny_data.txt file, suitable for reading back into R.  Note that
this is "wide" - we have not melted out the variables, but the rubric allows
for either wide or narrow summary data.
