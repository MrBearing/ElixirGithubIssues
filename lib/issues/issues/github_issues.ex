defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent","Elixir dave@pragporog.com"} ]

  def fetch(user, project)do
    issues_url(user,project)
    |>HTTPoison.get(@user_agent)
    |>handle_response
  end

  # コンパイル時に値を取得する為にもじゅーつ属性を使う
  @github_url Application.get_env(:issues, :github_url)
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok , %{status_code: 200, body: body}})do
    {:ok , Poison.Parser.parse!(body)}
  end

  def handle_response({____, %{status_code: ___, body: body}})do
    {:error, Poison.Parser.parse!(body)}
  end


end
