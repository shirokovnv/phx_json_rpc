defmodule PhxJsonRpc.Error.InvalidParams do
  @moduledoc """
  An error meaning

  ```
  - Invalid method parameter(s).
  ```
  """
  use PhxJsonRpc.Error,
    message: "Invalid params",
    code: -32_602
end
