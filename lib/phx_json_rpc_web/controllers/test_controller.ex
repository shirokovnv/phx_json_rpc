defmodule PhxJsonRpcWeb.TestController do
  @moduledoc false

  alias PhxJsonRpc.Error.ServerError

  @doc false
  def hello(%{"name" => name}) do
    "Hello, #{name}"
  end

  @doc false
  def internal_error(_params) do
    raise "oops"
  end

  def server_error(_params) do
    raise ServerError
  end

  @doc false
  def without_schema_ref(_params) do
    "no validation provided"
  end
end
