defmodule GrepCnt do

  def grep_cnt(scheduler) do
    send scheduler, {:ready, self}
    receive do
      {:gc, filename, client} ->
        send client, {:answer, filename, _grep_cnt(filename), self}
        grep_cnt(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  defp _grep_cnt(filename) do
    data = fileread(filename)
    Regex.scan(~r/cat/, data)
    |> length
  end

  defp fileread(filename) do
    case File.read(filename) do
      {:ok, data} -> data
      {_, error} -> "error"
    end
  end

end

defmodule Scheduler do

  def run(path, module, func) do
    to_calculate = File.ls!(path)
    num_processes = File.ls!(path) |> length
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(to_calculate, [])
    |> print_table
  end

  def schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {:gc, next, self}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, filename, result, _pid} ->
        schedule_processes(processes, queue, [ {filename, result} | results ])

    end
  end

  defp print_table(results) do
    :io.format("~-50s | ~-11s |~n", ["absname", "cat counter"])

    results
    |> Enum.each(fn({absname, counter}) ->
      :io.format("~-50s | ~-11s |~n", [absname, to_string(counter)])
    end)
  end
end


path = "/Users/yamadakazuki/.ghq/github.com/tamanugi/elixir-process-tutorial/"
Scheduler.run(path, GrepCnt, :grep_cnt)
