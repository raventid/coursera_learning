defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(key) do
    # Thereis a long explanation why we have to link first and then update
    # ets tables. (Possible race condition :((((( non language is perfect)
    Process.link(Process.whereis(__MODULE__))

    # Good registry implementation could be found here.
    # https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/registry.ex
    if :ets.insert_new(__MODULE__, {key, self()}) do
      :ok
    else
      :error
    end
  end

  def whereis(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, pid}] -> pid
      [] -> nil
    end
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, _) do
    {:noreply, remove_by_pid(pid)}
  end

  def handle_info(other, state) do
    super(other, state)
  end

  defp remove_by_pid(pid) do
    :ets.match_delete(__MODULE__, {:_, pid})
  end
end

# SimpleRegistry.start_link() # PID<...>
# SimpleRegistry.register(:some_name) # :ok
# SimpleRegistry.register(:some_name) # :error
# SimpleRegistry.whereis(:some_name) # PID<...>
# SimpleRegistry.whereis(:unregistered_name) # nil
