defmodule Transformer do
  @moduledoc """
  Transforms transactions based on the account type
  """

  alias Transaction

  @spec transform([Transaction.t()], :asset | :liability) :: [Transaction.t()]
  def transform(transactions, :asset), do: transactions

  def transform(transactions, :liability) do
    Enum.map(transactions, fn %Transaction{} = tx ->
      %Transaction{tx | amount: -tx.amount, type: flip(tx.type)}
    end)
  end

  defp flip(:credit), do: :debit
  defp flip(:debit), do: :credit
end
