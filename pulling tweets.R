#After registeration, every user will get their own keys 
consumer_key = "Your key"
consumer_secret = "Your key"
access_token = "Your key"
access_secret = "Your key"

#pull tweets containing "bioweapon" word
library(rtweet)
bioweapon_tweets <- search_tweets(q = '"bioweapon" AND "China" OR "Chinese" OR "Wuhan"',
                                  n = 3200)
biolab_tweets <- search_tweets(q = '"lab" AND "China" OR "Chinese" OR "Wuhan"',
                                  n = 3200)

save_as_csv(bioweapon_tweets,"bioweapon_pulled_tweets/bioweapon0610.csv")
save_as_csv(biolab_tweets,"biolab_pulled_tweets/biolab0610.csv")




