defmodule ParserTest do
  use ExUnit.Case
  alias Transaction
  alias Parser

  @fake_txt_content """
  Data        Lançamento                Valor (R$)
  10/04/2026  PIX RECEBIDO JOAO         150,00    
  12/04/2026  PGTO BOLETO LUZ          -100,50    
  """

  describe "parse/1" do
    test "correctly parses valid transactions and ignore headers" do
      result = Parser.parse(@fake_txt_content)

      assert length(result) == 2

      [transaction1, transaction2] = result

      assert transaction1 == %Transaction{
        date: "20260410",
        description: "PIX RECEBIDO JOAO",
        amount: 150.0,
        type: :credit
      }

      assert transaction2 == %Transaction{
        date: "20260412",
        description: "PGTO BOLETO LUZ",
        amount: -100.5,
        type: :debit
      }
    end
  end
end
