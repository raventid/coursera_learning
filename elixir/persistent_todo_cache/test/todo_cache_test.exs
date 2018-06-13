defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache_pid} = Todo.Cache.start

    bob_pid = Todo.Cache.server_process(cache_pid, "bob")

    assert bob_pid != Todo.Cache.server_process(cache_pid, "alice")
    assert bob_pid == Todo.Cache.server_process(cache_pid, "bob")
  end

  test "to-do operation" do
    {:ok, cache_pid} = Todo.Cache.start
    alice = Todo.Cache.server_process(cache_pid, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-09-09], title: "Some note"})
    entries = Todo.Server.entries(alice, ~D[2018-09-09])

    assert [%{date: ~D[2018-09-09], title: "Some note"}] = entries
  end
end
