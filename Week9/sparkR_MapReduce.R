library(magrittr)

# SETUP------------------------------------------------------------------------
# Point SPARK_HOME to where you put spark directory
Sys.setenv(SPARK_HOME = "/Users/xgu/spark-1.6.0-bin-hadoop2.6")

# Load SparkR package
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Create Spark Context for using Spark
# It uses 4 cores, assign 8G memory to worker, and load package handling csv 
# You may want to modify these setting according to your computer hardware
sc <- sparkR.init("local[4]", 
                  sparkEnvir = list(spark.executor.memory="8g"),
                  sparkPackages = "com.databricks:spark-csv_2.11:1.3.0")

# Create SQL context
sqlContext <- sparkRSQL.init(sc)

# Map Reduce-------------------------------------------------------------------
# read file (Use ::: to cess non-exported function): umass twitter
# each line is a record
umass <- SparkR:::textFile(sc, "umass_tt.txt")

first(umass)   # First record
count(umass)   # How many records
take(umass, 5) # take first 5 records

# Map function: each record map to number of characters
num_chars <- SparkR:::map(umass, nchar)
collect(num_chars)     #collect to R data

# Reduce function: sum all character counts
# Reduce function with two arguments x, y to combine two mapped records
# Here we just sum x and y
reduce_fun <- function(x, y) x + y
SparkR:::reduce(num_chars, reduce_fun)

# World Counts--------------------------------------------------------------------
# We map each line to a list of key-value pairs (word, 1), 
# then reduce by word to obtain word coutns
map_wc <- function(line) {
  line <- gsub("[[:punct:]]", "", line)
  words <- strsplit(line, " ")[[1]]
  lapply(words, function(word) list(word, 1))
}

umass1 <- SparkR:::flatMap(umass, map_wc)   # map to bag of words

# For any two records with same key, perform reduce function to one new record
# e.g. ('umass', 1) and ('umass', 1) reduce to ('umass', 2)
word_counts <- SparkR:::reduceByKey(umass1, "+", 10) %>% collect()

# process the results in R
wordc <- sapply(word_counts, function(x) x[[2]])
names(wordc) <- sapply(word_counts, function(x) x[[1]])
sort(wordc, decreasing = TRUE) %>% head(30)
