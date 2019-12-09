# file copied from credo
defmodule Credo.Test.FilenameGenerator do
  use GenServer

  def start_link(opts \\ []) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def next do
    number = GenServer.call(__MODULE__, {:next})
    "test-untitled.#{number}.ex"
  end

  # callbacks

  def init(_) do
    {:ok, 1}
  end

  def handle_call({:next}, _from, current_state) do
    {:reply, current_state + 1, current_state + 1}
  end
end

defmodule Credo.Test.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Credo.Test.FilenameGenerator, [])
    ]

    opts = [strategy: :one_for_one, name: Credo.Test.Application.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
