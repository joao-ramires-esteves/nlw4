defmodule Rocketpay.NumbersTest do
  # modulo pra unit testing
  use ExUnit.Case, async: true

  # alias do modulo pra poder usar ele suave
  alias Rocketpay.Numbers

  describe "sum_from_file/1" do
    test "file with the given name, return sum" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 47}}

      assert response == expected_response
    end

    test "no file, return error" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "nofile"}}

      assert response == expected_response
    end
  end
end
