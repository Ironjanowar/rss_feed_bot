defmodule RssFeedBot.Bot do
  @bot :rss_feed_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  alias RssFeedBot.Redis

  def bot(), do: @bot

  def format_feed_map(%{title: title, description: description, link: link, pub_date: pub_date}) do
    "*[#{pub_date}]* _#{title}_\n#{link}\n\n    #{description}"
  end

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

  def handle({:command, "get", %{chat: %{id: uid}, text: text}}, context) do
    case Integer.parse(text) do
      {number, ""} ->
        RssFeedBot.Rss.get_last_user_feeds(uid, number)
        |> Enum.map(&format_feed_map/1)
        |> Enum.map(
          &ExGram.send_message(uid, &1, parse_mode: "Markdown", disable_web_page_preview: true)
        )

      _ ->
        answer(context, "That's not a valid number")
    end
  end
end
