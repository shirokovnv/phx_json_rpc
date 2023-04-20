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
