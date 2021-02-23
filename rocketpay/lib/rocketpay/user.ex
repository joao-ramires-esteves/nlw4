defmodule Rocketpay.User do
  @moduledoc """
  module que define um User\n como se fosse um "model"
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @primary_key { :id, :binary_id, autogenerate: true }

  @required_params [:name, :age, :email, :password, :nickname]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true ## virtual eh essencial p/ esconder
    field :password_hash, :string
    field :nickname, :string

    timestamps()
  end

  def changeset(params) do            ## sanitiza
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params) ## altos validate possiveis
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/) ## regex pra qlq coisa entre @
    |> unique_constraint([:email])    ## deixando uniq => importante
    |> unique_constraint([:nickname])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{ valid?: true, changes: %{password: var_password} } = var_changeset ) do
    change(var_changeset, Bcrypt.add_hash(var_password))
  end

  defp put_password_hash(changeset), do: changeset ## changeset invalido so devolve ele
end
