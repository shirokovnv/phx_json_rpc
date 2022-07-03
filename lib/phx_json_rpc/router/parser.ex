defmodule PhxJsonRpc.Router.Parser do
  @moduledoc """
  Parse behaviour for the rpc requests.
  """
  alias PhxJsonRpc.Request

  @doc """
  Parses request, checking it's version, method and parameters.

  If parse fails, returns request with `%PhxJsonRpc.Error.ParseError{}` struct and set `valid?` parameter to false.
  """
  @callback parse(request :: map(), schema_version :: binary()) :: Request.t()
end

defmodule PhxJsonRpc.Router.DefaultParser do
  @moduledoc false

  @behaviour PhxJsonRpc.Router.Parser

  alias PhxJsonRpc.Request
  alias PhxJsonRpc.Error.{InvalidRequest, ParseError}

  @fields %{
    version: "jsonrpc",
    method: "method",
    params: "params",
    id: "id"
  }

  @impl true
  def parse(request, schema_version) when is_map(request) do
    version = Map.get(request, @fields.version)
    method = Map.get(request, @fields.method)
    params = Map.get(request, @fields.params, [])
    id = Map.get(request, @fields.id)

    if valid_request?(version, method, params, id, schema_version) do
      Request.new(version: version, method: method, params: params, id: id, valid?: true)
    else
      error = %InvalidRequest{}

      Request.new(
        version: version,
        method: method,
        params: params,
        id: id,
        valid?: false,
        error: error
      )
    end
  end

  @impl true
  def parse(_request, _schema_version) do
    error = %ParseError{}
    Request.new(error: error, valid?: false)
  end

  defp valid_request?(version, method, params, id, schema_version) do
    version == schema_version && is_binary(method) && (is_list(params) || is_map(params)) &&
      (is_nil(id) || is_binary(id) || is_number(id))
  end
end
