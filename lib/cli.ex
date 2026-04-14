defmodule CLI do
  @moduledoc """
  Command line interface entrypoint.
  """

  def main(args) do
    case args do
      [input_file, output_file] ->
        process(input_file, output_file)

      _ ->
        IO.puts("Usage: ./text_to_ofx <input_file.txt> <output_file.txt>")
    end
  end

  defp process(input_file, output_file) do
    IO.puts("Reading #{input_file}...")

    input_file
    |> File.read!()
    |> Parser.parse()
    |> OfxBuilder.build()
    |> then(&File.write!(output_file, &1))

    IO.puts("Successfully created #{output_file}!")
  end
end
