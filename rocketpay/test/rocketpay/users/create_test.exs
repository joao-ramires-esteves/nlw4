defmodule Rocketpay.Users.CreateTest do
  # aqui tem um errors_on daora, deixa o test mais legivel e faz em sandbox
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when params valid, returns user" do
      params = %{
        name: "rafael",
        password: "123456",
        nickname: "camarda",
        email: "rafael@banana.com",
        age: 27
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      # o pin operator ^ fixa o valor mesmo com pattern matching
      assert %User{name: "rafael", age: 27, id: ^user_id} = user
    end

    test "when param invalid, returns error" do
      params = %{
        name: "rafael",
        nickname: "camarda",
        email: "rafael@banana.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) === expected_response
    end
  end # do describe
end # do modulo
