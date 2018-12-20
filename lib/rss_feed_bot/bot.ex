defmodule RssFeedBot.Bot do
  @bot :rss_feed_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  alias RssFeedBot.Redis

  def bot(), do: @bot

  def handle({:command, "start", _msg}, context) do
    answer(context, "Well hello!\n Send me the *RSS* you want to subscribe",
      parse_mode: "Markdown"
    )
  end

  def handle({:command, "add", %{chat: %{id: uid}, text: text}}, context) do
    Redis.add_link(uid, text)

    answer(context, "Added link #{text} to your *RSS* feed", parse_mode: "Markdown")
  end

  def handle({:command, "links", %{chat: %{id: uid}}}, context) do
    {:ok, links} = Redis.get_links(uid)

    formated_links =
      case links |> Enum.map(&("- " <> &1)) |> Enum.join("\n") do
        "" -> "You don't have any links\nUse `/add <link>` to add one"
        formated_links -> formated_links
      end

    answer(context, formated_links, parse_mode: "Markdown")
  end
end
