defmodule Rocketpay.Users.Create do
@moduledoc """
modulo pra automatizar colocar um user no banco de dados\n
automatiza com a call/1 o sanitizamento e insert
"""
  alias Rocketpay.{Repo, User} ## modulos q serao usados aq

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
