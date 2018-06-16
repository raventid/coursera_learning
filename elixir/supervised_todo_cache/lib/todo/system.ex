defmodule Todo.System do
  use Supervisor

  # By default supervisor makes
  # 3 restarts in 5 seconds.
  # After 3 restarts exhausted
  # it just halts the system.
  # EXIT reason: shutdown.
  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  # This approach with callback module
  # is a more flexible solution because
  # we gain the ability to perform hot reload.
  @impl Supervisor
  def init(_) do
    children = [
      Todo.ProcessRegistry,
      Todo.Cache,
      Todo.Database
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
