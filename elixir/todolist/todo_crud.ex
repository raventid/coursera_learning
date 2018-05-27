defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList {}

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    %TodoList{ todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1 }
  end

  def update_entry(todo_list, entry_id, update_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry} ->
        new_entry = update_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)

        %TodoList{ todo_list | entries: new_entries }
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end

# For REPL:
# todo_list = TodoList.new()
# todo_list = TodoList.add_entry(todo_list, %{date: ~D[2017-10-10], title: "Hello"})
# TodoList.delete_entry(todo_list, ~D[2017-10-10])
# TodoList.delete_entry(todo_list, 1)
