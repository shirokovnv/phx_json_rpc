defmodule PhxJsonRpcWeb.TestMiddleware do
  @moduledoc false
  use PhxJsonRpc.Router.Middleware

  def handle(request, context) do
    if context.meta_data.test do
      request
    else
      raise "Test not passed"
    end
  end
end
