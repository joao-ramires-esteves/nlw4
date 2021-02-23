defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  def create(conn, params) do  # uma action
    params                     # recebidos via POST
    |> Rocketpay.create_user()
    |> handle_response(conn)
  end

  defp handle_response( {:ok, %User{} = var_user }, conn) do
    conn
    |> put_status(:created)
    |> render("create.json", user: var_user)
  end

  defp handle_response({:error, result}, conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
