defmodule PhxJsonRpc.Error.ParseError do
  @moduledoc """
  An error occurred on the server while parsing the JSON text.
  """
  use PhxJsonRpc.Error,
    message: "Parse error",
    code: -32_700
end
