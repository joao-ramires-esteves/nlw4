defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate

  # quando der um create_user/1 vai chamar a call/1 do modulo ali
  defdelegate create_user(params), to: UserCreate, as: :call
end
