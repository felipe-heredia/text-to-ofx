defmodule Transaction do
  @moduledoc """
  Represents a parsed bank transaction
  """

  @enforce_keys [:date, :description, :amount, :type]
  defstruct [:date, :description, :amount, :type] 

  @type t :: %__MODULE__ {
    date: String.t(),
    description: String.t(),
    amount: float(),
    type: :credit | :deit
  }
end
