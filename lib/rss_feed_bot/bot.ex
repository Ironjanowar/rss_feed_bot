defmodule RssFeedBot.Bot do
  @bot :rss_feed_bot

  use ExGram.Bot,
    name: @bot

  def bot(), do: @bot

  def handle({:command, "start", _msg}, context) do
    answer(context, "Well hello!\n Send me the *RSS* you want to subscribe",
      parse_mode: "Markdown"
    )
  end
end
