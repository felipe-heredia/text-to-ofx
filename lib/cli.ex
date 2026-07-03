defmodule CLI do
  @moduledoc """
  Command line interface entrypoint.
  """

  def main(args) do
    {opts, _rest, invalid} =
      OptionParser.parse(args, strict: [input_file: :string, output_file: :string, type: :string])

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
    type = Keyword.get(opts, :type)

    process(input_file, output_file, type)
  end

  defp process(input_file, output_file, type) do
    IO.puts("Reading #{input_file}...")

    with {:ok, type} <- to_type(type || "asset"),
    {:ok, content} <- File.read(input_file) do
      content
      |> Parser.parse()
      |> Transformer.transform(type)
      |> OfxBuilder.build()
      |> then(&File.write!(output_file, &1))

    IO.puts("Successfully created #{output_file}!")
    else {:error, {:unknown_type, val}} ->
      IO.puts("Error: unknown type #{inspect(val)}. Use: asset | liability")
      System.halt(1)

      {:error, :enoent} ->
        IO.puts("Error: file not found: #{input_file}")
        System.halt(1)
    end
  end

  defp to_type("asset"), do: {:ok, :asset}
  defp to_type("liability"), do: {:ok, :liability}
  defp to_type(other), do: {:error, {:unknown_type, other}}
end
