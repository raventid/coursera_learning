defmodule Todo.Cache do
  use GenServer

  # Rename this to start_link, so everyone
  # understand that we are running with
  # supervisor.
  def start_link(_) do
    IO.puts("Starting supervised cache.")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Let's use name instead of cache_pid, so
  # we can freely delte first parameter.
  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  # GenServer callbacks.
  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}
      :error ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)

        {
          :reply,
          new_server,
          Map.put(todo_servers, todo_list_name, new_server)
        }
    end
  end
end

# FOR REPL:
# {:ok, cache_pid} = Todo.Cache.start
# Todo.Cache.server_process(cache_pid, "My list")
# Todo.Cache.server_process(cache_pid, "Another guy list")

# Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
# bobs_list = Todo.Cache.server_process("Bob's list")
