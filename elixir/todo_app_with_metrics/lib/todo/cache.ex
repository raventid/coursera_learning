defmodule Todo.Cache do
  use GenServer

  # Rename this to start_link, so everyone
  # understand that we are running with
  # supervisor.
  def start_link do
    IO.puts("Starting supervised cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  # FIXME: This is our bottleneck now.
  # We always ask supervisor to start
  # child. And it will always do this
  # one by one.

  # Let's change a bit the overall design
  # will ask dynamic supervisor to start
  # child and if will tell us is this child
  # already exists or not and will give us
  # PID of child.
  def server_process(todo_list_name) do
    case start_child(todo_list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  # Helper for previous function.
  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Todo.Server, todo_list_name}
    )
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
