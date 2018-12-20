defmodule RssFeedBot do
  use Application

  import Supervisor.Spec

  require Logger

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(RssFeedBot.Bot, [:polling, token]),
      {Redix, [host: "localhost", name: :redix]},
      worker(RssFeedBot.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: RssFeedBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting RssFeedBot")
        ok

      error ->
        Logger.error("Error starting RssFeedBot")
        error
    end
  end
end
