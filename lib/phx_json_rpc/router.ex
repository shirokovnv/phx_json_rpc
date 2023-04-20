defmodule PhxJsonRpc.Router do
  @moduledoc """
  The entrypoint for defining rpc routes.

  ## Config
    * `otp_app` - name of the OTP application.

    * `schema` - specifies path to your json-schema file.

    * `version` - jsonrpc version.

    * `max_batch_size` - maximum number of requests per batch.

  ### Example

      defmodule MyRpcRouter do
        use PhxJsonRpc.Router,
          otp_app: :rpc_router,
          schema: "[PATH_TO_OPENRPC_SCHEMA]",
          version: "2.0",
          max_batch_size: 20

        rpc("greet", HelloController, :hello)
      end

  ## OTP customization (optional)

  You can override pipeline for handling requests, by adding extra-params in `config` file.

  All the options should implement specific behaviour.

  If option is not present in the config, it will be setted to the package defaults.

  * `parser` - should implement `PhxJsonRpc.Router.Parser`

  * `validator` - should implement `PhxJsonRpc.Router.Validator`

  * `dispatcher` - should implement `PhxJsonRpc.Router.Dispatcher`

  ### Example

  ```
    config :rpc_router, MyRpcRouter,
      parser: MyRpc.Parser,
      validator: MyRpc.Validator,
      dispatcher: MyRpc.Dispatcher
  ```
  """

  defmacro __using__(opts) do
    schema = Keyword.fetch!(opts, :schema)
    version = Keyword.fetch!(opts, :version)
    max_batch_size = Keyword.fetch!(opts, :max_batch_size)
    otp_app = Keyword.fetch!(opts, :otp_app)

    if !is_binary(schema), do: raise(ArgumentError, message: "Schema name must be string.")
    if !is_binary(version), do: raise(ArgumentError, message: "Version must be string.")

    if !(is_integer(max_batch_size) && max_batch_size > 0),
      do: raise(ArgumentError, message: "Maximum batch size must be positive integer.")

    if !is_atom(otp_app), do: raise(ArgumentError, message: "OTP App must me an atom.")

    quote do
      import unquote(__MODULE__)

      alias PhxJsonRpc.Router.SchemaResolver

      Module.register_attribute(__MODULE__, :json_schema, accumulate: false)
      Module.register_attribute(__MODULE__, :routes, accumulate: true)
      Module.register_attribute(__MODULE__, :middleware, accumulate: false)

      @json_schema SchemaResolver.resolve(unquote(schema))
      @version unquote(version)
      @max_batch_size unquote(max_batch_size)
      @otp_app unquote(otp_app)

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

    * `schema_ref` - reference inside json schema, used for request params validation (optional).

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

  @doc """
  Keeps user-defined middleware.

  ## Arguments
    * `middleware_group` - enumeration of the list of the middleware modules.

  ## Examples
      middleware(MyMiddlewareOne, MyMiddlewareTwo)
  """
  defmacro middleware(middleware_group) do
    quote do
      @middleware unquote(middleware_group)
    end
  end

  # credo:disable-for-next-line
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
      def get_routes do
        @routes
      end

      @impl true
      def get_json_schema do
        @json_schema
      end

      @impl true
      def get_version do
        @version
      end

      @impl true
      def get_max_batch_size do
        @max_batch_size
      end

      @impl true
      def get_otp_app do
        @otp_app
      end

      def get_middleware do
        @middleware
      end

      def handle(requests, meta_data \\ nil) do
        ctx_instance = Context.build(__MODULE__, meta_data)
        DefaultPipe.handle(requests, ctx_instance)
      end
    end
  end
end
