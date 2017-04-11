defmodule Stack.Supervisor do
  use Supervisor

  def start_link(initial_stack) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [initial_stack])
    start_workers(sup, initial_stack)
    result
  end

  def start_workers(sup, initial_stack) do
    # スタッシュワーカーを開始
    {:ok, stash} =
      Supervisor.start_child(sup, worker(Stack.Stash, [initial_stack]))

    # そして、実際のsequenceサーバのスーパーバイザを開始
    Supervisor.start_child(sup, supervisor(Stack.SubSupervisor, [stash]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

end
