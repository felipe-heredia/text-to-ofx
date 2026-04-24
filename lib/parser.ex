defmodule Parser do
  @moduledoc """
  Parses raw text data into Transaction structs.
  """

  alias Transaction

  @doc """
  Takes a full text file lines and returns a list of Transactions.
  """

  @spec parse(String.t()) :: [Transaction.t()]
  def parse(raw_text) do
    raw_text
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reject(&is_nil/1)
  end

  # The Regex looks for:
  # 1. Date (DD/MM/YYYY)
  # 2. Description (anything in the middle)
  # 3. Value (Format: -1.000,50 or 150,00)
  defp parse_line(line) do
    case Regex.run(~r/^(\d{2}\/\d{2}(?:\/\d{4})?)\s+(.+?)\s+(-?[\d\.]+,\d{2})/, String.trim(line)) do
      [_, date_str, desc, amount_str] ->
        amount = parse_amount(amount_str)

        %Transaction{
          date: format_date_for_ofx(date_str),
          description: String.trim(desc),
          amount: amount,
          type: if(amount >= 0, do: :credit, else: :debit)
        }

      nil ->
        nil
    end
  end

  # Converts "150,00" or "-1.049,50" into standard Floats
  defp parse_amount(amount_str) do
    amount_str
    |> String.replace(".", "")
    |> String.replace(",", ".")
    |> Float.parse()
    |> elem(0)
  end

  # Converts "DD/MM/YYYY" to "YYYYMMDD"
  defp format_date_for_ofx(date_str) do
    case String.split(date_str, "/") do
      [day, month, year] ->
        "#{year}#{month}#{day}"

      [day, month] ->
        current_year = Date.utc_today().year |> Integer.to_string()
        "#{current_year}#{month}#{day}"
    end
  end
end
