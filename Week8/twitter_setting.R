consumer_key <- "3yQNVIZCgjVEX191m1qKhbiIu"
consumer_secret <- "kfT6bbKlwXh4HDFPUhLyUPq9sMuD6oWzJPEbJFC6vtPlKomqxV"
access_token <- "960801247-keWx3HmZDJEmfV54WFd4nGd4cHvIUykSl5mSgnrj"
access_secret <- "WfCPyqBQIPchZewvwBWTsp7RB6VYMZmDmPuSvHuKVIAz2"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# 
# header = list(Authorization = 'OAuth', 
#               oauth_consumer_key="3yQNVIZCgjVEX191m1qKhbiIu", 
#               oauth_nonce="54f077566c5f4497592a53175b485ac1", 
#               oauth_signature="sFY9T6ExBlaKIO3kXBvV0XZwJBk%3D", 
#               oauth_signature_method="HMAC-SHA1", 
#               oauth_timestamp="1457104385", 
#               oauth_token="960801247-keWx3HmZDJEmfV54WFd4nGd4cHvIUykSl5mSgnrj",
#               oauth_version="1.0")
# GET('https://api.twitter.com/1.1/',
#     add_headers(Authorization = 'OAuth', 
#                 oauth_consumer_key="3yQNVIZCgjVEX191m1qKhbiIu", 
#                 oauth_nonce="54f077566c5f4497592a53175b485ac1", 
#                 oauth_signature="sFY9T6ExBlaKIO3kXBvV0XZwJBk%3D", 
#                 oauth_signature_method="HMAC-SHA1", 
#                 oauth_timestamp="1457104385", 
#                 oauth_token="960801247-keWx3HmZDJEmfV54WFd4nGd4cHvIUykSl5mSgnrj",
#                 oauth_version="1.0"))