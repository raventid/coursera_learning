defmodule Todo.DatabaseWorker do
  use GenServer

  # Client interface
  def start_link(folder_name) do
    # IO.puts("Starting database worker #{worker_id}")

    # GenServer.start_link(
    #   __MODULE__,
    #   folder_name,
    #   name: via_tuple(worker_id)
    # )
    #
    # Let's change this to poolboy version
    GenServer.start_link(__MODULE__, folder_name)
  end

  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  # Callback for GenServer
  @impl GenServer
  def init(folder_name) do
    {:ok, folder_name}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, folder_name) do
    key
    |> file_name(folder_name)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, folder_name}
  end

  @impl GenServer
  def handle_call({:get, key}, _, folder_name) do
    data = case File.read(file_name(folder_name, key)) do
             {:ok, contents} -> :erlang.binary_to_term(contents)
             _ -> nil
           end

    {:reply, data, folder_name}
  end

  defp file_name(folder_name, key) do
    Path.join(folder_name, to_string(key))
  end
end
