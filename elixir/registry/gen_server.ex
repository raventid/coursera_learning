defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(key) do
    GenServer.call(__MODULE__, {:register, key})
  end

  def whereis(key) do
    GenServer.call(__MODULE__, {:whereis, key})
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, key}, {pid, reference}, state) do
    {status, new_state} = if Map.has_key?(state, key) do
      {:error, state}
    else
      Process.link(pid)
      {:ok, Map.put(state, key, pid)}
    end

    {:reply, status, new_state}
  end

  @impl GenServer
  def handle_call({:whereis, key}, _, state) do
    val = case Map.fetch(state, key) do
      {:ok, val} -> val
      :error -> nil
    end

    {:reply, val, state}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    {:noreply, remove_by_pid(state, pid)}
  end

  def handle_info(other, state) do
    super(other, state)
  end

  defp remove_by_pid(state, pid) do
    keys = state
    |> Stream.filter(fn {key, val} -> val == pid end)
    |> Enum.map(fn {key, val} -> key end)

    Map.drop(state, keys)
  end
end

# SimpleRegistry.start_link() # PID<...>
# SimpleRegistry.register(:some_name) # :ok
# SimpleRegistry.register(:some_name) # :error
# SimpleRegistry.whereis(:some_name) # PID<...>
# SimpleRegistry.whereis(:unregistered_name) # nil
