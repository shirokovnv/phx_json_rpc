defmodule PhxJsonRpc.Router.Middleware do
  @moduledoc """
  Middleware interface for the group of routes.

  Request must have `:valid => true` for passing through the next middleware.

  ### Example

      defmodule AuthMiddleware do
        use PhxJsonRpc.Router.Middleware

        @impl true
        def handle(request, context) do
          if context.meta_data.is_authenticated
            request
          else
            request
            |> Map.put(:valid?, false)
            |> Map.put(:error, %AuthError{})
          end
        end
      end

      defmodule AuthError do
        use PhxJsonRpc.Error,
          message: "Unauthenticated",
          code: -32_000
      end
  """

  defmacro __using__(_opts) do
    quote do
      @behaviour PhxJsonRpc.Router.Middleware
    end
  end

  alias PhxJsonRpc.Request
  alias PhxJsonRpc.Router.Context

  @doc """
  Handles request before it will be dispatched to the controller.
  """
  @callback handle(request :: Request.t(), context :: Context.t()) :: Request.t()
end

defmodule PhxJsonRpc.Router.DefaultMiddleware do
  @moduledoc false

  alias PhxJsonRpc.Error.InternalError
  alias PhxJsonRpc.Logger

  def handle(request, context) do
    middleware_group = context.instance.get_middleware()

    handle_middleware_group(middleware_group, request, context)
  end

  def handle_middleware_group(middleware_group, request, context)
      when is_list(middleware_group) do
    Enum.reduce(middleware_group, request, fn middleware, req ->
      if req.valid? do
        middleware.handle(req, context)
      else
        req
      end
    end)
  rescue
    e ->
      Logger.log_error(request.id, e, __STACKTRACE__)

      request
      |> Map.put(:valid?, false)
      |> Map.put(:error, %InternalError{message: Exception.format(:error, e)})
  end

  def handle_middleware_group(_, request, context) do
    request
  end
end
