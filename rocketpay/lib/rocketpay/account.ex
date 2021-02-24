defmodule Rocketpay.Account do
  @moduledoc """
  module que define uma account, linkando ela\n
  com um user\n
  tipo um model tbm
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.User

  @primary_key { :id, :binary_id, autogenerate: true }
  @foreign_key_type :binary_id

  @required_params [ :balance, :user_id ]

  schema "accounts" do
    field :balance, :decimal
    belongs_to :user, User


    timestamps()
  end

  def changeset(params) do  # sanitiza
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params) # altos validate possiveis
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
