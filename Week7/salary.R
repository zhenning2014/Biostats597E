library(rvest)
library(dplyr)

# STEP 1: get some faculty names
faculty_names <- read_html("https://www.pse.umass.edu/faculty/listing") %>%
  html_nodes(".even div div div div div strong a") %>%
  html_text()

# get first and last names
faculty_names <- gsub("[[:punct:]]", "", faculty_names)
faculty_names <- strsplit(faculty_names, " ")
first_last <- lapply(faculty_names, function(x) x[c(1, length(x))])

# function to get salary give last name and first name
get_salary <- function(first, last) {
  # link of salary of UMASS employee given last name
  link <- sprintf("http://www.bostonherald.com/news_opinion/databases/payroll?database=-2&year=2&last_name=%s&department_name=University+of+Massachusetts", last)
  # get all salaries maching the last name
  salary <- read_html(link) %>% html_table()
  if (length(salary) == 0) return(NULL)
  salary <- salary[[1]]
  # subset to match first name
  salary <- salary[grepl(paste0("^", first), salary[, 1], ignore.case = TRUE), ]
  Sys.sleep(1)
  print(salary)
  return(salary)
}

# get all salaries
salaries <- lapply(first_last, function(x) get_salary(x[1], x[2]))

salaries <- do.call("rbind", salaries)
