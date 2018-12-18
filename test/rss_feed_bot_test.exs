defmodule RssFeedBotTest do
  use ExUnit.Case
  doctest RssFeedBot

  test "greets the world" do
    assert RssFeedBot.hello() == :world
  end
end
