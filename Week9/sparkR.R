# SETUP------------------------------------------------------------------------
# Point SPARK_HOME to where you put spark directory
Sys.setenv(SPARK_HOME = "/Users/xgu/spark-1.6.0-bin-hadoop2.6")

# Load SparkR package
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Create Spark Context for using Spark
# It uses 4 cores, assign 2G memory to worker, and load package handling csv 
# You may want to modify these setting according to your computer hardware
sc <- sparkR.init("local[4]", 
                  sparkEnvir = list(spark.executor.memory="2g"),
                  sparkPackages = "com.databricks:spark-csv_2.11:1.3.0")

# Create SQL context
sqlContext <- sparkRSQL.init(sc)

# Read Data as Spark DataFrame-------------------------------------------------
# inferSchema: whether not infer schema (e.g. variable types)
df <- read.df(sqlContext, 
              path = "../local/USCensus1990.data.txt",
              source = "com.databricks.spark.csv",
              header = "true")

# First a fiew records
head(df)

# How many records
count(df)

# Print schema
printSchema(df)






