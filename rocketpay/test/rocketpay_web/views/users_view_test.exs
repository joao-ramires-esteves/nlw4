defmodule RocketpayWeb.UsersViewTest do
  # pra view usa o conncase
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "rafael",
      password: "123456",
      nickname: "camarda",
      email: "rafael@banana.com",
      age: 27
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
     Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "user created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "rafael",
        nickname: "camarda"
      }
    }

    assert expected_response == response
  end
end
