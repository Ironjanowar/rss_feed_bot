defmodule RssFeedBot.Redis do
  def add_link(uid, link) do
    Redix.pipeline(:redix, [["LPUSH", uid, link], ["LPUSH", "users", uid]])
  end

  def get_links(uid) do
    Redix.command(:redix, ["LRANGE", uid, 0, -1])
  end

  def get_links!(uid) do
    Redix.command!(:redix, ["LRANGE", uid, 0, -1])
  end

  def get_all_users() do
    Redix.command(:redix, ["LRANGE", "users", 0, -1])
  end
end
