defmodule PhxJsonRpc.Error.ServerError do
  @moduledoc """
  Reserved for implementation-defined server-errors.
  """
  use PhxJsonRpc.Error,
    message: "Server error",
    code: -32_000
end
