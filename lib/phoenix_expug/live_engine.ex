# Source: https://github.com/slime-lang/phoenix_slime/issues/71

defmodule PhoenixExpug.LiveEngine do
  @moduledoc ~S"""
  Phoenix LiveView template engine for Expug.
  """

  @behaviour Phoenix.Template.Engine

  @expug_options [
    raw_helper: "raw",
    escape_helper: ""
  ]

  @doc """
  Precompiles the String file_path into a function defintion, using Calliope engine
  """
  def compile(path, _name) do
    path
    |> read!
    |> EEx.compile_string(engine: Phoenix.LiveView.Engine, file: path, line: 1)
  end

  defp read!(file_path) do
    try do
      file_path |> File.read! |> Expug.to_eex!(@expug_options)
    rescue
      error in [Expug.Error] ->
        reraise %Expug.Error{error |
          message: "#{file_path}: " <> error.message}, System.stacktrace
      error ->
        reraise error, System.stacktrace
    end
  end
end
