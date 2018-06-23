defmodule Todo.Database do
  @db_folder "./persist"

  def start_link do
    File.mkdir_p!(@db_folder)

    children = Enum.map(1..3, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp worker_spec(worker_id) do
    default_worker_spec = { Todo.DatabaseWorker, { @db_folder, worker_id } }
    Supervisor.child_spec(default_worker_spec, id: worker_id)
  end

  # Let's just change typespecs and work with them.
  # Instead of handwritten:
  # %{
  #  id: __MODULE__,
  #    start: {__MODULE__, :start_link, []},
  #    type: :supervisor
  # }
  #
  # We'll add a poolboy dependency and use it.
  def child_spec(_) do
    File.mkdir_p!(@db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 3
      ],
      [@db_folder]
    )
  end

  # We had this here:
  # key
  # |> choose_worker()
  # |> Todo.DatabaseWorker.store(key, data)
  #
  def store(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
      end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end

  defp choose_worker(key) do
    :erlang.phash2(key, 3) + 1
  end
end
