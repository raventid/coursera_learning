defmodule WorkWithProcess do
  def run_query(query_def) do
    Process.sleep(2000)
    "#{query_def} result"
  end

  def spawned_run_query(query_def) do
    spawn(fn -> run_query(query_def) end)
  end
end
