defmodule PhxJsonRpc.Error.InvalidParams do
  @moduledoc """
  Invalid method parameter(s).
  """
  use PhxJsonRpc.Error,
    message: "Invalid params",
    code: -32_602
end
