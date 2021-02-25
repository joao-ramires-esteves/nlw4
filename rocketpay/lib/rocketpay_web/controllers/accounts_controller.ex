defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account

  # deu ruim vem pro fallback
  action_fallback RocketpayWeb.FallbackController

  # uma action
  def deposit(conn, params) do
    with { :ok, %Account{} = var_account } <- Rocketpay.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: var_account)
    end
  end

  def withdraw(conn, params) do
    # no caso de ok pega a conta e chama a facade
    with { :ok, %Account{} = var_account } <- Rocketpay.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: var_account)
    end
  end

  def transaction(conn, params) do
    with { :ok, %{} = var_transaction } <- Rocketpay.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: var_transaction)
    end
  end
end
