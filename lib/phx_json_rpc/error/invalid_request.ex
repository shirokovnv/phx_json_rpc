defmodule PhxJsonRpc.Error.InvalidRequest do
  @moduledoc """
  The JSON sent is not a valid Request object.
  """

  use PhxJsonRpc.Error,
    message: "Invalid request",
    code: -32_600
end
