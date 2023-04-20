defmodule PhxJsonRpcWeb.TestController do
  @moduledoc false

  alias PhxJsonRpc.Error.ServerError

  def hello(%{"name" => name}, _context) do
    "Hello, #{name}"
  end

  def internal_error(_params, _context) do
    raise "oops"
  end

  def server_error(_params, _context) do
    raise ServerError
  end

  def without_schema_ref(_params, _context) do
    "no validation provided"
  end
end
