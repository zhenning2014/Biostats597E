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

# Read Data as Spark DataFrame-------------------------------------------------
# path: file path, we can put a folder or multiple files separated by ,
# inferSchema: whether not infer schema (e.g. variable types)
df <- read.df(sqlContext, 
              path = "../local/2013-american-community-survey/pums/ss13pusa.csv",
              source = "com.databricks.spark.csv",
              header = "true",
              inferSchema = "true")

# Useful variables---
# PUMA: zip code
# ST: State code (25 is MA)
# AGEP: age
# PINCP: Total person's income
# SCHL: education level (21 bachelor, 24 is doctorate)

# Basic Data Information-------------------------------------------------------
# First a fiew records
head(df)

# How many records
count(df)

# Print schema (variable types)
printSchema(df)

# Some other R data frame functions also work
nrow(df)
ncol(df)
names(df)

# Data manuplation: dplyr way---------------------------------------------------
# filter records
df_ma <- filter(df, df$ST == 25)

# select subset of variables
df_sub <- select(df, "PUMA", "ST", "AGEP", "PINCP")

# Grouping and Aggregation
counts <- groupBy(df, df$ST) %>% summarize(count = n(df$ST))
collect(counts)
arrange(counts, desc(counts$count)) %>% collect()

age <- groupBy(df, "ST") %>% summarize(age = mean(df$AGEP))
arrange(age, age$age) %>% collect()

# create new variable
df$age1 <- df$AGEP / 10

# Data manuplation: sql way-----------------------------------------------------
# I much prefer this method, which is so much more consistent than dplyr like
# Register the data frame as a table in SQL
registerTempTable(df, "df")

# for each state obtain average age and sort
q <- "select ST, mean(AGEP) as age from df group by ST order by age desc"
sql(sqlContext, q) %>% collect()

# percentage of doctorate degree, which state most educated
q <- "select ST, count(*) as n, 
      mean(case when SCHL=24 then 1 else 0 end) as doctor 
      from df group by ST order by doctor desc"
sql(sqlContext, q) %>% collect()

# does higher degree earn more?
q <- "select education, mean(PINCP) as income
      from (select case when SCHL=24 then 'Doctor'
                        when SCHL in (22, 23) then 'MS'
                        when SCHL=21 then 'BS'
                        else 'Other' end as education,
                   PINCP from df) as t1
      group by education"
sql(sqlContext, q) %>% collect()

