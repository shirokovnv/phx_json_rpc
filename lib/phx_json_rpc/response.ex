defmodule PhxJsonRpc.Response do
  @moduledoc """
  Basic struct for the rpc response
  """
  defstruct [:version, :data, :id, :valid?, :error]

  import PhxJsonRpc.Types, only: [parse_params: 2]
  alias PhxJsonRpc.Types

  @typedoc """
  Type represents structure for the rpc response.
  """
  @type t :: %__MODULE__{
          version: Types.jsonrpc_version(),
          data: Types.rpc_response(),
          id: Types.rpc_request_id(),
          valid?: boolean(),
          error: Types.rpc_error()
        }

  @doc """
  Creates the new rpc response from the given params.

  ## Examples

      iex> PhxJsonRpc.Response.new(version: "2.0", data: "hello", id: "[REQUEST-UUID]", valid?: true)
      %PhxJsonRpc.Response{
        version: "2.0",
        data: "hello",
        id: "[REQUEST-UUID]",
        valid?: true,
        error: nil
      }

  """
  @spec new(Keyword.t()) :: t
  def new(params \\ []) do
    parse_params(%__MODULE__{}, params)
  end

  @doc """
  Creates an empty rpc response.

  ## Examples

      iex> PhxJsonRpc.Response.empty()
      %PhxJsonRpc.Response{
        version: nil,
        data: nil,
        id: nil,
        valid?: false,
        error: nil
      }

  """
  @spec empty(boolean()) :: t
  def empty(valid \\ false) do
    %__MODULE__{valid?: valid}
  end
end
