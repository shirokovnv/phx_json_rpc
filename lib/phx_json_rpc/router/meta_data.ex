defmodule PhxJsonRpc.Router.MetaData do
  @moduledoc """
  MetaData struct for the paths, defined in rpc router.

  Contains information about called controllers, actions and schema references for the given rpc method.
  """
  defstruct [:controller, :action, :schema_ref]

  import PhxJsonRpc.Types, only: [parse_params: 2]

  @typedoc """
  Type represents structure for the rpc metadata.
  """
  @type t :: %__MODULE__{
          controller: nil | module(),
          action: nil | atom(),
          schema_ref: nil | binary()
        }

  @doc """
  Creates the new metadata from the given params.

  ## Examples

      iex> PhxJsonRpc.Router.MetaData.new(controller: RpcController, action: :hello, schema_ref: "#/components/schema/hello")
      %PhxJsonRpc.Router.MetaData{
        controller: RpcController,
        action: :hello,
        schema_ref: "#/components/schema/hello"
      }

  """
  @spec new(Keyword.t()) :: t
  def new(params \\ []) do
    parse_params(%__MODULE__{}, params)
  end
end
