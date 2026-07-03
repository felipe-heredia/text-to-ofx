defmodule TransformTest do
  use ExUnit.Case, async: true

  test "asset leaves amounts unchanged when" do
    tx = %Transaction{date: "20260101", description: "Salary", amount: 100.0, type: :credit}
    assert Transformer.transform([tx], :asset) == [tx]
  end

  test "liability negates amount and flips type" do
    tx = %Transaction{date: "20260101", description: "Store", amount: 50.0, type: :credit}
    [result] = Transformer.transform([tx], :liability)
    assert result.amount == -50.0
    assert result.type == :debit
    assert result.date == "20260101"
  end
end
