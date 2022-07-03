defmodule PhxJsonRpc.Request do
  @moduledoc """
  Basic struct for the rpc request.
  """
  defstruct [:version, :method, :params, :id, :valid?, :error]

  import PhxJsonRpc.Types, only: [parse_params: 2]
  alias PhxJsonRpc.Types

  @typedoc """
  Type represents structure for the rpc request.
  """
  @type t :: %__MODULE__{
          version: Types.jsonrpc_version(),
          method: Types.rpc_request_method(),
          params: Types.rpc_request_params(),
          id: Types.rpc_request_id(),
          valid?: boolean(),
          error: Types.rpc_error()
        }

  @doc """
  Creates the new rpc request from the given params.

  ## Examples

      iex> PhxJsonRpc.Request.new(version: "2.0", method: "hello", params: %{"name" => "John"}, id: "[REQUEST-UUID]")
      %PhxJsonRpc.Request{
        version: "2.0",
        method: "hello",
        params: %{"name" => "John"},
        id: "[REQUEST-UUID]",
        valid?: nil,
        error: nil
      }

  """
  @spec new(Keyword.t()) :: t
  def new(params \\ []) do
    parse_params(%__MODULE__{}, params)
  end
end
