defmodule PhxJsonRpc.Router.DispatcherTest do
  use ExUnit.Case
  alias PhxJsonRpc.Error.{InvalidParams, MethodNotFound}
  alias PhxJsonRpc.Router.DefaultDispatcher
  alias PhxJsonRpc.Router.{Context, MetaData}
  alias PhxJsonRpc.{Request, Response}
  alias PhxJsonRpcWeb.TestController

  @context Context.build(nil, nil)

  test "dispatches valid request" do
    request = %Request{method: "hello", id: "ID", params: %{"name" => "Ron"}, valid?: true}
    meta = %MetaData{controller: TestController, action: :hello}

    assert DefaultDispatcher.dispatch(request, meta, @context) ===
             %Response{data: "Hello, Ron", id: "ID", valid?: true}
  end

  test "invalid params" do
    request = %Request{
      method: "hello",
      id: "ID",
      params: %{"lastname" => "Weasley"},
      valid?: true
    }

    meta = %MetaData{controller: TestController, action: :hello}

    expected_error = %InvalidParams{}

    assert DefaultDispatcher.dispatch(request, meta, @context) ===
             %Response{error: expected_error, id: "ID", valid?: false}
  end

  test "not found" do
    request = %Request{method: "unknown_method", id: "ID", params: %{}, valid?: true}
    meta = %MetaData{controller: TestController, action: :unknown_method}

    expected_error = %MethodNotFound{}

    assert DefaultDispatcher.dispatch(request, meta, @context) ===
             %Response{error: expected_error, id: "ID", valid?: false}
  end
end
