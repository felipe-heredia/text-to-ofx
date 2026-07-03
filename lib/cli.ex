defmodule CLI do
  @moduledoc """
  Command line interface entrypoint.
  """

  def main(args) do
    {opts, _rest, invalid} =
      OptionParser.parse(args, strict: [input_file: :string, output_file: :string])

    if invalid != [] do
      IO.puts("Invalid options: #{inspect(invalid)}")
      System.halt(1)
    end

    missing =
      [:input_file, :output_file]
      |> Enum.reject(fn key -> Keyword.has_key?(opts, key) end)

    if missing != [] do
      IO.puts("Missing required options: #{Enum.join(missing, ", ")}")
      System.halt(1)
    end

    input_file = Keyword.get(opts, :input_file)
    output_file = Keyword.get(opts, :output_file)
    IO.inspect({input_file, output_file})

    process(input_file, output_file)
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
