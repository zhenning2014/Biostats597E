#' Function to perform indeed job search
#'
#' @description This function perform job scraping given
#' query string, location, and page number
#'
#' @param publisher_id the publisher id for the web api
#' @param q query string
#' @param l location
#' @param start page number
#'
#' @return a data frame
#'
#' @examples
#' jobsearch("4892433118027808", q = "data scientist", l = "boston, ma", start = 1)
#'
jobsearch <- function(publisher_id, q, l, start) {
  require(httr)
  q <- list(publisher = publisher_id,
            v = 2,
            q = q,
            l = l,
            start = start,
            format = "json")
  res <- GET("http://api.indeed.com/ads/apisearch", query = q)
  jsonlite::fromJSON(content(res, "text"))$results
}

#' Function to extract job summary for a given url
#'
#' @param url the url of the job summary
#'
#' @return the text field of the job summary
#'
#' @examples
#' res <- jobsearch("4892433118027808", q = "data scientist", l = "boston, ma", start = 1)
#' jobsum <- sapply(res$url, job_summary)
#'
job_summary <- function(url) {
  require(rvest)
  read_html(url) %>%
    html_nodes("#job_summary") %>%
    html_text()
}
