defmodule RssFeedBot.Rss do
  require Logger

  alias RssFeedBot.Redis

  defp get_floki_child!({_, _, [child]}), do: child
  defp get_floki_child!([{_, _, [child]}]), do: child
  defp get_floki_child!(_), do: ""

  defp get_feed_map(item) do
    [title, link, description, pub_date] =
      ["title", "link", "description", "pubdate"]
      |> Enum.map(&Floki.find(item, &1))
      |> Enum.map(&get_floki_child!/1)
      |> Enum.map(&String.trim/1)

    %{
      title: title,
      link: link,
      description: HtmlSanitizeEx.strip_tags(description),
      pub_date: pub_date
    }
  end

  def get_all_items(url) do
    case HTTPoison.get(url) do
      {:ok, %{body: body}} ->
        body
        |> Floki.find("item")

      {:error, err} ->
        Logger.error(err)
        :error
    end
  end

  def get_feed(url) do
    url |> get_all_items() |> Enum.map(&get_feed_map/1)
  end

  def get_last_feeds(url, number \\ 1) do
    url |> get_all_items() |> Enum.take(number) |> Enum.map(&get_feed_map/1)
  end

  def get_last_user_feeds(uid, number) do
    Redis.get_links!(uid) |> get_last_feeds(number)
  end
end
