defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  # deu ruim vem pro fallback
  action_fallback RocketpayWeb.FallbackController

  # uma action
  def create(conn, params) do
    # se veio tudo ok, manda pra criar o user usano params vindo do json
    with { :ok, %User{} = var_user } <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: var_user)
    end
  end
end
