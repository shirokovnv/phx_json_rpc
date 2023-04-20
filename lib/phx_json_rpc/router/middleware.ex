defmodule PhxJsonRpc.Router.Middleware do
  @moduledoc """
  Middleware interface for the group of routes.
  """

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

  def handle(request, context) do
    middleware_group = context.instance.get_middleware()

    handle_middleware_group(middleware_group, request, context)
  end

  def handle_middleware_group(middleware_group, request, context)
      when is_list(middleware_group) do
    Enum.reduce(middleware_group, %{}, fn middleware, acc ->
      if request.valid? do
        middleware.handle(request, context)
      else
        request
      end
    end)
  rescue
    e ->
      request
      |> Map.put(:valid?, false)
      |> Map.put(:error, %InternalError{message: Exception.format(:error, e)})
  end

  def handle_middleware_group(_, request, context) do
    request
  end
end
