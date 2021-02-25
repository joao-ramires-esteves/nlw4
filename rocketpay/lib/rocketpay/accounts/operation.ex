defmodule Rocketpay.Accounts.Operation do
  @moduledoc """
  modulo que, no contexto de accounts, abstrai\n
  as operacoes de saque e deposito
  """
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{ "id" => var_id, "value" => var_value}, operation) do
    # chama a func pra poder n dar grosope com o Multi, isso eh um nome dinamico
    operation_name = account_operation_name(operation)
    # inicia transaction
    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, var_id) end)
    # se deu certo update
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)
      update_balance(repo, account, var_value, operation) end)
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

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
  end
end
