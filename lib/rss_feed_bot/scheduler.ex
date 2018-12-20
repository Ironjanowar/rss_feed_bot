defmodule RssFeedBot.Scheduler do
  use Quantum.Scheduler,
    otp_app: :rss_feed_bot

  alias RssFeedBot.Redis
  require Logger

  defp format_feed(%{title: title, description: description, link: link, pub_date: pub_date}) do
    "*[#{pub_date}]* _#{title}_\n#{link}\n\n    #{description}"
  end

  defp send_rss_message({user, feeds}) do
    feeds
    |> List.flatten()
    |> Enum.map(&format_feed/1)
    |> Enum.map(&ExGram.send_message(user, &1, parse_mode: "Markdown"))
  end

  defp get_links_by_user({links, user}) do
    {user, Enum.map(links, &RssFeedBot.Rss.get_feed/1)}
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
        |> Enum.map(&send_rss_message/1)
    end
  end
end
