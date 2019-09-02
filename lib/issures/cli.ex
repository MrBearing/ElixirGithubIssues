
defmodule Issues.CLI do
    @default_count 4

    @moduledoc """
    コマンドライン引数のパースをして、特定の関数に引数を受け渡す
    """

    def run(argv) do
        parse_args(argv)
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
end