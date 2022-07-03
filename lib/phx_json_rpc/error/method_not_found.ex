defmodule PhxJsonRpc.Error.MethodNotFound do
  @moduledoc """
  An error meaning

  ```
  - The method does not exist / is not available.
  ```
  """
  use PhxJsonRpc.Error,
    message: "Method not found",
    code: -32_601
end
