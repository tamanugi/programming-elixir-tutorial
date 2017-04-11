defmodule Stack.Server do
  use GenServer

  ## 外部API

  def start_link(init_stack) do
    GenServer.start_link(__MODULE__, init_stack, name: __MODULE__)
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(new) do
    GenServer.cast __MODULE__, {:push, new}
  end

  ## GenServerの実装

  def init(stash_pid) do
    current_stack = Stack.Stash.get_value stash_pid
    { :ok, {current_stack, stash_pid}}
  end

  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    { :reply, head, { tail, stash_pid } }
  end

  def handle_cast({:push, new}, { current_stack, stash_pid }) do
    { :noreply, { [new | current_stack], stash_pid }}
  end

  def terminate(_reason, {current_stack, stash_pid}) do
    Stack.Stash.save_value stash_pid, current_stack
  end

end
