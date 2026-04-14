defmodule OfxBuilder do
  @moduledoc """
  Generates an OFX XML string from a list of transactions.
  """
  require EEx

  # EEx.function_from_string compiles this template directly into a fast
  # function called render_ofx/1
  EEx.function_from_string(
    :def,
    :render_ofx,
    """
    OFXHEADER:100
    DATA:OFXSGML
    VERSION:102
    SECURITY:NONE
    ENCODING:USASCII
    CHARSET:1252
    COMPRESSION:NONE
    OLDFILEUID:NONE
    NEWFILEUID:NONE

    <OFX>
      <BANKMSGRSV1>
        <STMTTRNRS>
          <TRNUID>1001</TRNUID>

          <STATUS>
            <CODE>0</CODE>
            <SEVERITY>INFO</SEVERITY>
          </STATUS>

          <STMTRS>
            <CURDEV>BRL</CURDEF>
            <BANKACCTFROM>
              <BANKID>341</BANKID>
              <ACCTID>0000</ACCTID>
              <ACCTTYPE>CHECKING</ACCTTYPE>
            </BANKACCTFROM>
            <BANKTRANLIST>
              <%= for tx <- transactions do %>
              <STMTTRN>
                <TRNTYPE><%= if tx.type == :credit, do: "CREDIT", else: "DEBIT" %></TRNTYPE>
                <DTPOSTED><%= tx.date %>120000[-03:BRT]</DTPOSTED>
                <TRNAMT><%= tx.amount %></TRNAMT>
                <FITID><%= tx.date %><%= abs(tx.amount) %></FITID>
                <MEMO><%= tx.description %></MEMO>
              </STMTTRN>
              <% end %>
            </BANKTRANLIST>
          </STMTRS>
        </STMTTRNRS>
      </BANKMSGRSV1>
    </OFX>
    """,
    [:transactions]
  )

  @spec build([Transaction.t()]) :: String.t()
  def build(transactions) do
    render_ofx(transactions)
  end
end
