defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, var_result}) do
    var_result =
      var_result
      |> String.split(",")
      |> Stream.map(fn number -> String.to_integer(number) end)
      |> Enum.sum()

    {:ok, %{result: var_result}}
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "nofile"}}
end
