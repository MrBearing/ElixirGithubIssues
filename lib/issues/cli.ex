
defmodule Issues.CLI do
    @default_count 4
    import Issues.TableFormatter, only: [ print_table_for_column: 2 ]

    @moduledoc """
    コマンドライン引数のパースをして、特定の関数に引数を受け渡す
    """
    def run(argv) do
        argv
        |> parse_args
        |> process
    end

    @doc """
    `argv` に-h や--helpが入ってたら　:helpアトムを返す

    """
    def parse_args(argv) do
        parse = OptionParser.parse(argv,    switches: [help: :boolean],
                                            alias:    [h:    :help])
        case  parse  do
            {[help: true], _ , _}
                -> :help
            {_ , [user, project, count], _ }
            -> {user, project ,String.to_integer(count)}
            {_ , [user, project], _ }
            -> {user, project ,@default_count}
            _ -> :help    
        end
    end

    def process(:help) do
        IO.puts """
        usage: issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({user, project, count }) do
        Issues.GithubIssues.fetch(user, project)
        |>decode_response
        |>convert_to_list_of_maps
        |>sort_into_ascending_order
        |> Enum.take(count)
        |> print_table_for_column({"number","created_at","title"})
    end

    def decode_response({:ok, body}), do: body

    def decode_response({:error, some})do
      {_, message} = List.keyfind(some,"message",0)
      IO.puts "Error fetching from Github: #{message}}"
      System.halt(2)
    end

    def convert_to_list_of_maps(list) do
        list
        |> Enum.map(&Enum.into(&1, Map.new))
    end

    def sort_into_ascending_order(list_of_issues) do
      Enum.sort list_of_issues,
        fn i1 , i2 -> i1["created_at"] <= i2["created_at"] end
    end

end