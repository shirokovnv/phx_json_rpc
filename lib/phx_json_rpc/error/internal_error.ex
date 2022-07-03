defmodule PhxJsonRpc.Error.InternalError do
  @moduledoc """
  Internal JSON-RPC error.
  """
  use PhxJsonRpc.Error,
    message: "Internal error",
    code: -32_603
end
