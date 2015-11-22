library(data.table)

##### Some utilities

data_dir <- "./UCI HAR Dataset"

sroot <- function (dset) paste(data_dir, dset, sep="/")

fname <- function (dset, prefix) {
    paste(sroot(dset), "/", prefix, "_", dset, ".txt", sep="")
}

## merge training and test sets to create one data set
load_data_set <- function (sname) {
    features <- fread(fname(sname, "X"))
    activities <- fread(fname(sname, "y"))
    names(activities) <- "activities"
    subjects <- fread(fname(sname, "subject"))
    names(subjects) <- "subjects"
    ##combine into a single data table
    d <- cbind(features, subjects, activities)
}

merged_data <- function() {
    test <- load_data_set("test")
    train <- load_data_set("train")
    rbind(test, train)
}

## Extract only the measurements on the mean and standard deviation for each
## measurement

features <- function() {
    fread(paste(data_dir, "features.txt", sep="/"))
}

rname_inds <- function(){
     f <- features()[[2]]
    ##indices of columns with "mean" or "std" as substrings
    ##not clear whether things like "gravityMean" should be included
    ##we have omitted such.
    which(grepl("mean", f) | grepl("std", f))
}

extract_features <- function(dataset) {
    v <- rname_inds()
    
    ## we want to keep the subject and activty columns
    v <- c(v, ncol(dataset)-1, ncol(dataset))
    dataset[,v,with=FALSE]
}

## Use descriptive activity names to name the activities in the data set

anames <- function () {
    fread(paste(data_dir, "activity_labels.txt", sep="/"))
}

rename_activities <- function (dataset){
    a <- anames()[[2]]
    dataset$activities <- factor(dataset$activities, labels = a)
    dataset
}

## Appropriately label the data set with descriptive variable names

rename_variables <- function(dataset) {
    f <- features()[[2]]
    v <- rname_inds()
    names(dataset) <- c(f[v], names(dataset)[(ncol(dataset)-1):ncol(dataset)])
    dataset
}

do_steps <- function() {
    rename_variables(rename_activities(extract_features(merged_data())))
}

## From the data in the previous step create a second, independent tidy data
## set with the average of each variable for each activity and each subject.

averages <- function(dataset) {
    dataset[,lapply(.SD, mean), by=list(activities, subjects), .SDcols = 1:(ncol(dataset)-2)]
}

write_td <- function() {
    write.table(averages(do_steps()), file="tiny_data.txt", row.name=FALSE)
}
