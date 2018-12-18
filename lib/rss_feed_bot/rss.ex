defmodule RssFeedBot.Rss do
  require Logger

  defp get_floki_child!({_, _, [child]}), do: child
  defp get_floki_child!([{_, _, [child]}]), do: child

  defp get_feed_map(item) do
    [title, link, description] =
      ["title", "link", "description"]
      |> Enum.map(&Floki.find(item, &1))
      |> Enum.map(&get_floki_child!/1)
      |> Enum.map(&String.trim/1)

    %{title: title, link: link, description: HtmlSanitizeEx.strip_tags(description)}
  end

  def get_feed(url) do
    case HTTPoison.get(url) do
      {:ok, %{body: body}} ->
        body
        |> Floki.find("item")
        |> Enum.map(&get_feed_map/1)

      {:error, err} ->
        Logger.error(err)
    end
  end
end
