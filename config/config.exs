# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_gram,
  token: "376323488:AAG6nrWYOt4GXIJi8o1qB5BiRTdrx9tQSwo"

config :rss_feed_bot, RssFeedBot.Scheduler,
  jobs: [
    {"@daily", {RssFeedBot.Scheduler, :send_rss, []}}
  ]
