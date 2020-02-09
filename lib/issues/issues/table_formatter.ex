defmodule Issues.TableFormatter do
  @moduledoc false
  @doc """
  Takes a listof row data, where each row is aMaopp , and a list of
  headers. Prints a table to STDOUT of the data from each row identified by each header.
  That is, each header identifies a column, and thosse columns are extracted and printed from the row.0
  """
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

  @doc"""
  Given a list of rows, where each row contains a keyed list of columns,
  return a list containing lists of the data in each column.
  The `headers` parameter contains the listof columns to extract
  ## Example
    iex> list = [Enum.into([{"a", "1"},{"b","2"},{"c","3"}],%{}),
    ...>         Enum.into([{"a", "4"},{"b","5"},{"c","6"}],%{})]
    iex> Issues.TableFormatter.split_as_column(list, ["a","b","c"])
    [ ["1","4"],["2","5"],["3","6"] ]
  """
  def split_as_column(row_list, header_list) do
    for header <- header_list do
      for row <- row_list, do: make_string(row[header])
    end
  end
  @doc """
  Retrun a binary (string) version of our parameter
  ## Example
    iex>Issues.TableFormatter.make_string("a")
    "a"
    iex>Issues.TableFormatter.make_string(99)
    "99"
  """
  def make_string(str) when is_binary(str), do: str
  def make_string(str), do: to_string(str)
  @doc """
  find max width
  ## Example
    iex> data=[["cat","wombat","elk"],["mongoose","ant","gnu"]]
    iex> Issues.TableFormatter.max_width(data)
    [6,8]
  """
  def max_width(columns) do
    for column <- columns, do: column |> Enum.map(&String.length/1) |> Enum.max
  end
  @doc """
  Genereate the line  that gose below the column headings. It is a string of hyphens,
  with + signs where the bertical bar between the columns gose.

  ## Example
      iex> widths = [5,6,99]
      iex> Issues.TableFormatter.make_format(widths)
      "~-5s|~-6s|~-99s~n"
  """
  def make_format(column_width) do
    Enum.map_join(column_width, "|" , fn width -> "~-#{width}s" end ) <> "~n"
  end

  @doc """
  Genereate the line  that gose below the column headings. It is a string of hyphens,
  with + signs where the bertical bar between the columns gose.

  ## Example
      iex> widths = [5,6,9]
      iex> Issues.TableFormatter.separator(widths)
      "-----+------+---------"
  """
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
