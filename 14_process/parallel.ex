defmodule Parallel do

  import :timer, only: [ sleep: 1 ]

  def pmap(collection, fun) do
    me = self
    collection
    |> Enum.map(fn (elem) ->
         spawn_link fn -> (
          send me, {self, fun.(elem)}
         ) end
       end)
    |> Enum.reverse
    |> Enum.map(fn (pid) ->
         IO.inspect pid
         receive do { pid, result} -> [pid, result] end
       end)
  end
end