run_analysis <- function() {
  olddir = getwd()    # save the old working directory
  ## First, set the working directory
  ## to the appropriate root directory as noted in the README.md
  ## this should be the only edit you do in this script
  setwd("//bcinas1fs5/Profiles/kevi1000/Desktop/Big Data/Courses/Coursera/Getting and Cleaning Data")

  ## set the relative path
  path <- "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"

  ## we will combine files in a series of steps
  ## step 1 - combine test and training sets
  ## need to load the stringr library to make it easier
  library(stringr)
  ## start with test data
  filename <- str_c(path, '/test/X_test.txt')
  train_set_test <- read.table(filename, header=FALSE)
  
  ## add the variable labels - this is part 4 of the exercise
  filename <- str_c(path, '/features.txt')
  featureNames <- readLines(filename)
  colnames(train_set_test) <- c(featureNames)
  
  ## add the subject identifier
  filename <- str_c(path, '/test/subject_test.txt')
  subCol <- as.numeric(readLines(filename))

    ## convert to a column and cbind
  subCol <- as.matrix(subCol)
  train_set_test <- as.data.frame(cbind(train_set_test, subject=subCol))

    ## add labels
  filename <- str_c(path, '/test/y_test.txt')
  lblsCol <- as.data.frame(as.numeric(readLines(filename)))

    # change column name so we can merge later
  names(lblsCol) <- c("activityLabelId")
  train_set_test <- cbind(train_set_test, lblsCol)

  ## add activity labels - this is part 3 of the exercise
  filename <- str_c(path, '/activity_labels.txt')
  activityLables <- as.data.frame(read.csv(filename, header=FALSE, sep=" "))

  ## we need to add a new column with the activity label information
  ## do this via merge
  activityCol <- merge(lblsCol, activityLables, by.x = "activityLabelId", by.y = "V1")
  ## add the activity label column
  train_set_test <- cbind(train_set_test, activity = activityCol$V2)


  ## do same for training data  
  filename <- str_c(path, '/train/X_train.txt')
  train_set_train <- read.table(filename, header=FALSE)
  colnames(train_set_train) <- c(featureNames)
  
  filename <- str_c(path, '/train/subject_train.txt')
  subCol <- as.numeric(readLines(filename))
  subCol <- as.matrix(subCol)
  train_set_train <- cbind(train_set_train, subject = subCol)
  filename <- str_c(path, '/train/y_train.txt')

  lblsCol <- as.data.frame(as.numeric(readLines(filename)))
  names(lblsCol) <- c("activityLabelId")
  train_set_train <- as.data.frame(cbind(train_set_train, lblsCol))
  filename <- str_c(path, '/activity_labels.txt')

  activityLables <- as.data.frame(read.csv(filename, header=FALSE, sep=" "))
  activityCol <- merge(lblsCol, activityLables, by.x = "activityLabelId", by.y = "V1")
  train_set_train <- cbind(train_set_train, activity = activityCol$V2)
  
  ## put the sets together - this is part 1 of the exercise
  train_set <- rbind(train_set_train, train_set_test)
  ## cleanup old variables, free some memory
  rm("train_set_train")
  rm("train_set_test")
  ## extract mean and std of each measurement - part 2 of the exercise
  ## we are only interested in the first 561 columns for this obviously
  ## but we also want to preserve the 2 descriptive columns
  mean_col <- as.matrix(grep("+mean+", names(train_set)))
  std_col <- as.matrix(grep("+std+", names(train_set)))
  total_col <- rbind(mean_col, std_col)
  total_col <- rbind(total_col, 562)
  total_col <- rbind(total_col, 564)
  train_set_std_mean <- train_set[,total_col]
  ## cleanup old variables, free some memory
  rm("train_set")
  
  ## now we can create the tidy set, part 5 of exercise
  ## average of each variable for each activity and subject
  library(data.table)
  dt <- data.table(train_set_std_mean)
  tidy <- dt[, lapply(.SD, mean), by=.(subject, activity)]
  # make the column headers a tad more readable
  newColNames <- paste('Average - ', colnames(tidy))
  # fix the initial two columns
  newColNames[1] <- 'subject'
  newColNames[2] <- 'activity'
  colnames(tidy) <- c(newColNames)
  write.table(tidy, "tidy.txt", row.names = FALSE)
  setwd(olddir)
}
