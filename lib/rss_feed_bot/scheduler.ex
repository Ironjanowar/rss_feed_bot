defmodule RssFeedBot.Scheduler do
  use Quantum.Scheduler,
    otp_app: :rss_feed_bot

  alias RssFeedBot.Redis

  require Logger

  defp send_rss_message(feed, user) do
    formatted_feed = RssFeedBot.Bot.format_feed_map(feed)

    ExGram.send_message(user, formatted_feed,
      parse_mode: "Markdown",
      disable_web_page_preview: true
    )
  end

  defp send_rss_messages({all_feeds, user}) do
    # By now we don't care what is the origin of the feed
    all_feeds
    |> List.flatten()
    |> Enum.map(&send_rss_message(&1, user))
  end

  defp get_links_by_user({links, user}) do
    {Enum.map(links, &RssFeedBot.Rss.get_last_feeds(&1, 3)), user}
  end

  def send_rss() do
    case Redis.get_all_users() do
      {:ok, nil} ->
        :no_users

      {:ok, users} ->
        users
        |> Enum.map(&Redis.get_links!/1)
        |> Enum.zip(users)
        |> Enum.map(&get_links_by_user/1)
        |> Enum.map(&send_rss_messages/1)
    end
  end
end
