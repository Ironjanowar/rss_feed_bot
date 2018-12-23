defmodule RssFeedBot.Utils do
  require Logger

  def log_and_continue(elem, log \\ &Logger.debug/1) do
    elem |> inspect |> log.()

    elem
  end
end
