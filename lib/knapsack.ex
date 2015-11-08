
defmodule Sack do
    defstruct weight: 0, worth: 0
    def convert(map) when is_map(map) do
        %Sack{:weight => map["weight"], :worth => map["worth"]}
    end
end
defmodule Knapsack do
	def solve(list, index, capa) when capa < 0, do: :over
	def solve(list, index, capa) when length(list) == index, do: []
	def solve(list, index, capa) do
		sum? = fn
			resultList when resultList == :over -> -1
			resultList when resultList == [] -> 0
	    	resultList ->
	    		Enum.map(resultList, fn x -> x.worth end)
                |> Enum.sum
	    end
	    [
	    	solve(list, index+1, capa),
	    	solve(list, index+1, capa-Enum.at(list, index).weight)
	    	  |> case do
	    	    :over -> :over
			    x -> Enum.concat(x, [Enum.at(list, index)])
	    	  end
	    ] |> Enum.max_by(fn x -> sum?.(x) end)
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
		Enum.map(list, fn x -> Sack.convert(x) end)
            |> Knapsack.solve(0, size)
		    |> Enum.map(fn x -> x.worth end)
            |> Enum.sum |> IO.puts
	end
end