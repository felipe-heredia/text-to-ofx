defmodule TransformerTest do
  use ExUnit.Case, async: true

  describe "transform/2" do
    test "asset leaves amounts unchanged" do
      transactions = [
        %Transaction{date: "20260101", description: "Salary", amount: 100.0, type: :credit},
        %Transaction{
          date: "20260101",
          description: "Credit Card Payment",
          amount: 50.0,
          type: :debit
        }
      ]

      assert Transformer.transform(transactions, :asset) == transactions
    end

    test "liability negates amount and flips type" do
      transactions = [
        %Transaction{date: "20260101", description: "Market", amount: 10.5, type: :credit},
        %Transaction{date: "20260101", description: "Payment", amount: -50.0, type: :debit},
        %Transaction{date: "20260110", description: "Gas", amount: 12.0, type: :credit}
      ]

      result = Transformer.transform(transactions, :liability)
      [tx1, tx2, tx3] = result

      assert length(result) == length(transactions)


      assert tx1.amount == -10.5
      assert tx1.type == :debit

      assert tx2.amount == 50.0
      assert tx2.type == :credit

      assert tx3.amount == -12.0
      assert tx3.type == :debit
    end

    test "empty transactions should be transformed to empty" do
      assert Transformer.transform([], :liability) == []
      assert Transformer.transform([], :asset) == []
    end
  end
end
