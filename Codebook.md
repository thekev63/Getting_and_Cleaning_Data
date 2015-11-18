Codebook

Raw data:
The experiments have been carried out with a group of 30 subjects within an age bracket of 19-48 years.
There were six activities performed and recorded (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
Data comes from sensors and is partitioned into two datasets.

Processed data:
Raw data is combined into a single datafile and processed.  Variables consist of:

Mean value calculations by subject.
Standard deviation calculations by subject.
Activities are assigned according to the activity_labels.txt file and added as a column.
Subjects are assigned according to the respective subject_test/train files and added as a column.
Variables (columns) are labelled according to the features.txt file.

Tidy data is created from the processed data by averaging mean and standard deviation values aggregating by subject and activity.
