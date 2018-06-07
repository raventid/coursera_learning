defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  # Hides the interface of Actor(loop/0, run_query/1)
  # from caller.
  # Caller sees interaction as run_async -> result
  # Everything else is implementation detail.
  #
  # Now client has do this:
  # 1) Call start and receive PID
  # 2) It calls run_async with server PID and
  # query he wants to execute.
  # after this he gets the result.
  #
  # self() will be eagarly evaluated here, so
  # we'll get our PID, not a server one.
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  # After client used run_async function
  # he might want to read the result of query
  # to do this he needs to run get_results function
  # it will run receive(kernel function) and read
  # a message from mailbox of current process
  # it knows what message form is received from
  # DatabaseServer.
  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 -> {:error, :timeout}
    end
  end

  def loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end

    loop()
  end

  defp run_query(query_def) do
    Process.sleep(2000)
    "#{query_def} result"
  end
end
