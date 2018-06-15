defmodule Todo.Server do
  use GenServer

  # Client Interface.
  def start(name) do
    GenServer.start(__MODULE__, name)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  # Callback functions.
  @impl GenServer
  def init(name) do
    # If I start a very long operation here,
    # I may block caller process for a long
    # period of time. So we'll use one trick.

    # One important note about first signal:
    # If you initialize your process here,
    # without it being registered under global
    # name, then everything is fine. Your
    # message will be the first one you send
    # to yourself.
    # But if you are not using pid
    # and you are using named processes
    # then caller can send you a message
    # before you initialized your process
    # with :real_init. To avoid this
    # register process name right here
    # in init. And forbid standard way.
    send(self(), {:real_init, name})
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:real_init, name}, _) do
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)

    Todo.Database.store(name, new_state)
    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      todo_list
    }
  end
end

# {:ok, cache_pid} = Todo.Cache.start
# bobs_list = Todo.Cache.server_process(cache_pid, "bobs_list")
# Todo.Server.add_entry(bobs_list, %{date: ~D[2018-09-09], title: "Jul"})
