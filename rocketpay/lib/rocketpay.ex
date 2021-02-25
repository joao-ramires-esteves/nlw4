defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate

  alias Rocketpay.Accounts.{Deposit, Transaction, Withdraw}

  # quando der um create_user/1 vai chamar a call/1 do modulo ali
  defdelegate create_user(params), to: UserCreate, as: :call

  # outra facade, essa pra deposito
  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
