defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

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

defmodule TodoList.CsvImporter do
  @filename "todos.csv"
  @data_separator ","
  @date_separator "/"

  # {{year, month, date}, title}
  def import do
    @filename
    |> File.stream!
    |> Enum.map(&parse(&1))
    |> Enum.map(fn [date, title] -> create_entry(date, title) end)
    |> TodoList.new
  end

  defp parse(line) do
    String.split(line, @data_separator)
  end

  defp create_entry(date, title) do
    %{date: parse_date(date), title: title}
  end

  defp parse_date(date) do
    [year, month, day] =
      date
      |> String.split(@date_separator)
      |> Enum.map(&String.to_integer/1)
    Date.new(year, month, day)
  end
end
