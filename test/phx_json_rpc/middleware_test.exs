defmodule PhxJsonRpc.Router.MiddlewareTest do
  use ExUnit.Case
  alias PhxJsonRpc.Router.Middleware
  alias PhxJsonRpc.Error.InternalError
  alias PhxJsonRpc.{Request, Response}
  alias PhxJsonRpcWeb.{TestController, TestMiddleware}

  use PhxJsonRpc.Router,
    otp_app: :test_rpc,
    schema: "test/priv/static/openrpc.json",
    version: "2.0",
    max_batch_size: 20

  middleware([TestMiddleware])

  rpc("hello", TestController, :hello, "#/components/schemas/Name")

  test "request passes through middleware" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => %{"name" => "Ron"},
      "id" => "ID"
    }

    assert handle(request, %{test: true}) == %Response{
             version: "2.0",
             data: "Hello, Ron",
             id: "ID",
             valid?: true
           }
  end

  test "request doen't pass middleware" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => %{"name" => "Ron"},
      "id" => "ID"
    }

    expected_error = %InternalError{message: "** (RuntimeError) Test not passed"}

    assert handle(request, %{test: false}) == %Response{
             version: "2.0",
             data: nil,
             id: "ID",
             valid?: false,
             error: expected_error
           }
  end
end
