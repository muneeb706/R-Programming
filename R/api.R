myapp = oauth_app("your-app-name", key = "your-api-key", secret="your-api-secret")
sig = sign_oauth1.0(myapp, token="your-access-token", token_secret = "your-access-token-secret")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 = content(homeTL)
# converting it into data frame
json2 = jsonlite::fromJSON(jsonlite::toJSON(json1))
json2[1,1:4]
