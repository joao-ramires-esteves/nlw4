defmodule Rocketpay.Accounts.Operation do
  @moduledoc """
  modulo que, no contexto de accounts, abstrai\n
  as operacoes de saque e deposito
  """
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{ "id" => var_id, "value" => var_value}, operation) do
    # inicia transaction
    Multi.new()
    # tenta pegar a conta
    |> Multi.run(:account, fn repo, _changes -> get_account(repo, var_id) end)
    # se deu certo update
    |> Multi.run(:update_balance, fn repo, %{account: account} -> update_balance(repo, account, var_value, operation) end)
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "account not found"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
   # pegar o valor anterior e somar
   # cast pra validar
   account
   |> operation(value, operation)
   |> update_account(repo, account)
  end

  defp operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  # soma ou subtrai ou erro
  defp handle_cast( {:ok, value}, balance, :deposit ), do: Decimal.add(balance, value)
  defp handle_cast( {:ok, value}, balance, :withdraw ), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, _operation), do: {:error, "invalid deposit value"}

  defp update_account( {:error, _reason} = error, _repo, _account ), do: error

  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end
end
