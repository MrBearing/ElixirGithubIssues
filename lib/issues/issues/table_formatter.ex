defmodule Issues.TableFormatter do
  @moduledoc false

  def print_table_for_column(data_, header_list) do
    with columns_data = split_as_column(data_,header_list),
      width_list = max_width(columns_data),
      format = make_format(width_list)
    do
      puts_one_line_in_columns(header_list,format)
      IO.puts(separator(width_list))
      puts_in_columns(columns_data,format)
    end
  end

  def split_as_column(row_list, header_list) do
    for header <- header_list do
      for row <- row_list, do: make_string(row[header])
    end
  end

  def make_string(str) when is_binary(str), do: str
  def make_string(str), do: to_string(str)

  def max_width(columns) do
    for column <- columns, do: column |> Enum.map(&String.length/1) |> Enum.max
  end

  def make_format(column_width) do
    Enum.map_join(column_width, "|" , fn width -> "~-#{width}s" end ) <> "~n"
  end

  def separator(column_with) do
    Enum.map_join(column_with,"+",fn width -> List.duplicate("-",width) end)
  end
  def puts_in_columns(columns_data , format) do
    columns_data
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end
  def puts_one_line_in_columns(data, format) do
    :io.format(format,data)
  end
end
