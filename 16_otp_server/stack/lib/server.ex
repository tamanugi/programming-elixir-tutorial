defmodule Stack.Server do
  use GenServer

  ## 外部API

  ## GenServerの実装

  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end

  def handle_cast({:push, new}, current_stack) do
    { :noreply, [new | current_stack]}
  end

end
