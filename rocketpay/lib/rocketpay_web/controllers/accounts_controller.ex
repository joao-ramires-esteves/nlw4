defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

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
    task = Task.async(fn -> Rocketpay.transaction(params) end)
    # pode fazer qlq coisa aqui no meio por causa do await ali que retorna
    with { :ok, %TransactionResponse{} = var_transaction } <- Task.await(task) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: var_transaction)
    end
  end
end
