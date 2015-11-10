defmodule Sack do
  defstruct weight: 0, worth: 0
  def convert(%{"weight" => weight, "worth" => worth}) do
    %Sack{weight: weight, worth: worth}
  end
end

defmodule Knapsack do
  def solve(list, capa) do
    case solve(list, capa, 0) do
      :over -> []
      {resultList, _worth} -> resultList
    end
  end

  defp solve(_list,  capa, _worth) when capa < 0, do: :over
  defp solve(   [], _capa,  worth), do: {[], worth}
  defp solve([sack|rest], capa, worth) do
    sum? = fn
      :over -> -1
      {_, sum_worth} -> sum_worth
    end
    [
      solve(rest, capa, worth),
      solve(rest, capa - sack.weight, worth + sack.worth)
        |> case do
          :over -> :over
          {list, sum_worth} -> {[sack|list], sum_worth}
        end
    ] |> Enum.max_by(sum?)
  end
end

defmodule Main do
  def main(args) do
    {:ok, %{
        "goods" => list,
        "sack" => %{
              "capa" => size
              }}} = List.first(args)
                |> File.read!
                |> JSX.decode
    Enum.map(list, &Sack.convert/1)
      |> Knapsack.solve(size)
      |> Enum.map(fn x -> x.worth end)
      |> Enum.sum |> IO.puts
  end
end