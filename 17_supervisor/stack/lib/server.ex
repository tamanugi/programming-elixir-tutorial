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

  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end

  def handle_cast({:push, new}, current_stack) do
    { :noreply, [new | current_stack]}
  end

end
