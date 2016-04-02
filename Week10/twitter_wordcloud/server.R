library(shiny)
library(ggplot2)
library(tm)
library(twitteR)
library(wordcloud)
library(SnowballC)

# Twitter Setup
consumer_key <- "3yQNVIZCgjVEX191m1qKhbiIu"
consumer_secret <- "kfT6bbKlwXh4HDFPUhLyUPq9sMuD6oWzJPEbJFC6vtPlKomqxV"
access_token <- "960801247-keWx3HmZDJEmfV54WFd4nGd4cHvIUykSl5mSgnrj"
access_secret <- "WfCPyqBQIPchZewvwBWTsp7RB6VYMZmDmPuSvHuKVIAz2"
options(httr_oauth_cache=T)
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


shinyServer(function(input, output) {
   
  output$wordcloud <- renderPlot({
    tt <- searchTwitter(input$search, input$numtweets)
    tt <- sapply(tt, function(x) x$text)
    tt <- iconv(tt, "UTF-8", "ASCII", sub="")
    # Use tm to clean up texts
    tt <- Corpus(VectorSource(tt))
    tt <- tm_map(tt, PlainTextDocument)
    # remove punctuation
    tt <- tm_map(tt, removePunctuation)
    ## remove stop words like me my
    tt <- tm_map(tt, removeWords, stopwords('english'))
    tt <- tm_map(tt, content_transformer(tolower))
    tt <- tm_map(tt, removeWords, tolower(input$search))
    ## words stemming (walking -> walk)
    #tt <- tm_map(tt, stemDocument)
    # word cloud plot
    wordcloud(tt, min.freq = 3, max.words = 100,
              colors=brewer.pal(8, "Dark2"))  
  })
  
})
