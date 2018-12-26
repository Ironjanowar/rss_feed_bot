defmodule RssFeedBot.Redis do
  def add_link(uid, link) do
    Redix.pipeline(:redix, [["SADD", uid, link], ["SADD", "users", uid]])
  end

  def get_links(uid) do
    Redix.command(:redix, ["SMEMBERS", uid])
  end

  def get_links!(uid) do
    Redix.command!(:redix, ["SMEMBERS", uid])
  end

  def get_all_users() do
    Redix.command(:redix, ["SMEMBERS", "users"])
  end
end
