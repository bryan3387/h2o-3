setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source("../../../h2o-r/scripts/h2o-r-test-setup.R")
#----------------------------------------------------------------------
# Purpose:  This test exercises building 15MRows2KCols
#             
#----------------------------------------------------------------------
test <-
function() {

hdfs_name_node <- Sys.getenv(c("NAME_NODE"))
print(hdfs_name_node)

hdfs_data_file = "/datasets/bigdata/7MRows_4400KCols.csv"
#----------------------------------------------------------------------
# Parameters for the test.
#----------------------------------------------------------------------

url <- sprintf("hdfs://%s%s", hdfs_name_node, hdfs_data_file)
parse_time <- system.time(data.hex <- h2o.importFile(url))
print("Time it took to parse")
print(parse_time)

# Start modeling   
# DL 
response="C1" #1:1000 imbalance
predictors=c(4:ncol(data.hex))

dl_time <- system.time(mdl.dl <- h2o.deeplearning(x=predictors, y=response, training_frame=data.hex, replicate_training_data=FALSE, epochs=.1, hidden=c(5,5)))
mdl.dl
print("Time it took to build DL")
print(dl_time)

}

doTest("Test", test)

