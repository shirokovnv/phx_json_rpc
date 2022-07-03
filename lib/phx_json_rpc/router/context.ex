defmodule PhxJsonRpc.Router.Context do
  @moduledoc """
  Context that provides access to the stored route list, jsonrpc version and schema.
  """

  alias PhxJsonRpc.Router.MetaData

  @typedoc """
  Type represents the list of available routes.
  """
  @type route_list :: list({atom(), MetaData.t()})

  @doc """
  Returns the pre-defined list of routes.
  """
  @callback get_routes() :: route_list()

  @doc """
  Returns the json rpc version number.
  """
  @callback get_version() :: binary()

  @doc """
  Returns the pre-resolved json-schema.
  """
  @callback get_json_schema() :: map()
end
