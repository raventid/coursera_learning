defmodule TestHelper do
  # Hacky helper that loads the script from the test, then runs the test
  # and finally unloads all modules defined by the script.
  defmacro test_script(script_name, opts) do
    quote do
      test unquote(script_name) do
        modules = Code.load_file("#{__DIR__}/" <> unquote(script_name) <> ".ex")

        try do
          unquote(opts[:do])
        after
          Enum.each(modules, &:code.purge(elem(&1, 0)))
          Enum.each(modules, &:code.delete(elem(&1, 0)))
        end
      end
    end
  end
end

ExUnit.start()

defmodule Test do
  use ExUnit.Case, async: false
  import TestHelper

  test_script "gen_server" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register("foo") == :ok
    assert SimpleRegistry.register("foo") == :error
    assert SimpleRegistry.whereis("foo") == self()
    assert SimpleRegistry.whereis("bar") == nil

    {:ok, pid} = Agent.start_link(fn -> SimpleRegistry.register("bar") end)
    assert SimpleRegistry.whereis("bar") == pid
    Agent.stop(pid)
    :timer.sleep(100)
    assert SimpleRegistry.whereis("bar") == nil
  end

  test_script "ets" do
    SimpleRegistry.start_link()
    assert SimpleRegistry.register("foo") == :ok
    assert SimpleRegistry.register("foo") == :error
    assert SimpleRegistry.whereis("foo") == self()
    assert SimpleRegistry.whereis("bar") == nil

    {:ok, pid} = Agent.start_link(fn -> SimpleRegistry.register("bar") end)
    assert SimpleRegistry.whereis("bar") == pid
    Agent.stop(pid)
    :timer.sleep(100)
    assert SimpleRegistry.whereis("bar") == nil
  end
end
