defmodule PhxJsonRpc.Router do
  @moduledoc """
  The entrypoint for defining rpc routes.

  ## Example

      defmodule MyRpcRouter do
        use PhxJsonRpc.Router,
          schema: "[PATH_TO_OPENRPC_SCHEMA]",
          version: "2.0"

        rpc("greet", HelloController, :hello)
      end
  """

  defmacro __using__(opts) do
    schema = Keyword.fetch!(opts, :schema)
    version = Keyword.fetch!(opts, :version)

    if !is_binary(schema), do: raise(ArgumentError, message: "Schema name must be string.")
    if !is_binary(version), do: raise(ArgumentError, message: "Version must be string.")

    quote do
      import unquote(__MODULE__)

      alias PhxJsonRpc.Router.SchemaResolver

      Module.register_attribute(__MODULE__, :json_schema, accumulate: false)
      Module.register_attribute(__MODULE__, :routes, accumulate: true)

      @json_schema SchemaResolver.resolve(unquote(schema))
      @version unquote(version)

      @before_compile unquote(__MODULE__)
    end
  end

  @doc false
  def check_meta_constraints(method, controller, action, schema_ref) do
    if !is_binary(method), do: raise(ArgumentError, message: "Method name must be string.")

    if !is_atom(controller), do: raise(ArgumentError, message: "Controller must be an atom.")

    if !is_atom(action), do: raise(ArgumentError, message: "Action must be an atom.")

    if !(is_nil(schema_ref) || is_binary(schema_ref)),
      do: raise(ArgumentError, message: "Schema reference must be string or nil.")
  end

  @doc """
  Generates rpc route match based on the open-rpc schema parameters.

  ## Arguments
    * `method` - the name of the calling method.

    * `controller` - resolving module, often a controller.

    * `action` - resolving function in controller.

    * `schema_ref` - reference inside json schema, used for request params validation.

  ## Examples
      rpc("hello", HelloController, :hello)
      rpc("pet_create", PetController, :create, "#/components/schemas/NewPet")
  """

  defmacro rpc(method, controller, action, schema_ref \\ nil) do
    quote do
      check_meta_constraints(
        unquote(method),
        unquote(controller),
        unquote(action),
        unquote(schema_ref)
      )

      alias PhxJsonRpc.Router.MetaData

      @routes {
        unquote(String.to_atom(method)),
        MetaData.new(
          action: unquote(action),
          controller: unquote(controller),
          schema_ref: unquote(schema_ref)
        )
      }
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      if Enum.empty?(@routes), do: raise(ArgumentError, message: "No routes specified.")

      {:ok, list_of_methods} = ExJsonSchema.Schema.get_fragment(@json_schema, "#/methods")
      list_of_methods = Enum.map(list_of_methods, fn method -> method["name"] end)

      @routes
      |> Enum.each(fn {method, _meta} ->
        if !Enum.member?(list_of_methods, to_string(method)),
          do: raise(ArgumentError, message: "Method #{method} does not exist in schema.")
      end)

      alias PhxJsonRpc.Router.{Context, DefaultPipe}

      @behaviour Context

      @impl true
      def get_routes() do
        @routes
      end

      @impl true
      def get_json_schema() do
        @json_schema
      end

      @impl true
      def get_version() do
        @version
      end

      def handle(requests) do
        DefaultPipe.handle(requests, __MODULE__)
      end
    end
  end
end
