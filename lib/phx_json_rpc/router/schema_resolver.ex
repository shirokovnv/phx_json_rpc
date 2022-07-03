defmodule PhxJsonRpc.Router.SchemaResolver do
  @moduledoc """
  Module for resolving open rpc schema.
  """

  @doc """
  Resolves json schema by path.
  """
  @spec resolve(path :: binary()) :: ExJsonSchema.Root.t() | no_return
  def resolve(path) do
    Enum.join([File.cwd!(), path], "/")
    |> File.read!()
    |> Jason.decode!()
    |> ExJsonSchema.Schema.resolve()
  end
end
