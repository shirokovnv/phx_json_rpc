defmodule PhxJsonRpc.Router.Context do
  @moduledoc """
  Context that provides access to the stored route list, jsonrpc version and schema.
  """

  defstruct [:instance, :meta_data]

  @typedoc """
  Type represents structure for the rpc context.
  - :instance is typically the self-link
  - :meta_data, if present, is a map, containing user-defined params
  """
  @type t :: %__MODULE__{
          instance: module(),
          meta_data: map() | nil
        }

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

  @doc """
  Returns maximum size of the batch.
  """
  @callback get_max_batch_size() :: pos_integer()

  @doc """
  Returns the otp application name.
  """
  @callback get_otp_app() :: atom()

  @doc """
  Builds new context.

  ## Examples

      iex> PhxJsonRpc.Router.Context.build(Context, %{"hello" => "world"})
      %PhxJsonRpc.Router.Context{
        instance: Context,
        meta_data: %{"hello" => "world"}
      }
  """
  @spec build(module(), map() | nil) :: t
  def build(instance, meta_data \\ nil) do
    %__MODULE__{
      instance: instance,
      meta_data: meta_data
    }
  end
end
