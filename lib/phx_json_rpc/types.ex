defmodule PhxJsonRpc.Types do
  @moduledoc """
  Type definitions for the rpc requests, responses and errors.
  """

  alias PhxJsonRpc.Error.{
    InternalError,
    InvalidParams,
    InvalidRequest,
    MethodNotFound,
    ParseError,
    ServerError
  }

  @typedoc """
  Type represents jsonrpc version number.
  """
  @type jsonrpc_version :: binary()
  @typedoc """
  Type represents rpc request ID. Whether it's nil, string or number.
  """
  @type rpc_request_id :: nil | binary() | number()
  @typedoc """
  Type represents rpc request parameters. In terms of elixir, it's a list or a map.
  """
  @type rpc_request_params :: list(map()) | map()
  @typedoc """
  Type represents called rpc request method in the form of string.
  """
  @type rpc_request_method :: String.t()

  @typedoc """
  Type represents possible rpc errors.
  """
  @type rpc_error ::
          nil
          | InternalError.t()
          | InvalidParams.t()
          | InvalidRequest.t()
          | MethodNotFound.t()
          | ParseError.t()
          | ServerError.t()

  @typedoc """
  Type represents rpc response.
  """
  @type rpc_response :: any()

  @doc """
  Parses parameters, applying defaults by the given struct.
  """
  @spec parse_params(struct, Keyword.t()) :: any
  def parse_params(struct, params \\ []) do
    defaults = Map.from_struct(struct)

    Enum.reduce(defaults, struct, fn {key, default}, response ->
      value = Keyword.get(params, key, default)
      Map.put(response, key, value)
    end)
  end
end
