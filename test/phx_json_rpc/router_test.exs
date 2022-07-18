defmodule PhxJsonRpc.RouterTest do
  @moduledoc false

  use ExUnit.Case
  doctest PhxJsonRpc.Router

  use PhxJsonRpc.Router,
    otp_app: :test_rpc,
    schema: "test/priv/static/openrpc.json",
    version: "2.0",
    max_batch_size: 20

  alias PhxJsonRpc.Response

  alias PhxJsonRpc.Error.{
    InternalError,
    InvalidParams,
    InvalidRequest,
    MethodNotFound,
    ParseError,
    ServerError
  }

  alias PhxJsonRpcWeb.TestController

  rpc("hello", TestController, :hello, "#/components/schemas/Name")
  rpc("internal_error", TestController, :internal_error)
  rpc("server_error", TestController, :server_error)
  rpc("without_schema_ref", TestController, :without_schema_ref)

  test "valid response" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => %{"name" => "Ron"},
      "id" => "ID"
    }

    assert handle(request) == %Response{
             version: "2.0",
             data: "Hello, Ron",
             id: "ID",
             valid?: true
           }
  end

  test "internal error" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "internal_error",
      "params" => %{},
      "id" => "ID"
    }

    error = %InternalError{}
    assert handle(request) == %Response{version: "2.0", id: "ID", error: error, valid?: false}
  end

  test "invalid params" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => %{"lastname" => "Weasley"},
      "id" => "ID"
    }

    error_data = [
      {"Schema does not allow additional properties.", "#/lastname"},
      {"Required property name was not present.", "#"}
    ]

    error = %InvalidParams{data: error_data}
    assert handle(request) == %Response{version: "2.0", id: "ID", error: error, valid?: false}
  end

  test "invalid request" do
    request = %{
      "jsonrpc" => "1.0",
      "method" => "hello",
      "params" => [],
      "id" => "ID"
    }

    error = %InvalidRequest{}
    assert handle(request) == %Response{version: "1.0", id: "ID", error: error, valid?: false}
  end

  test "method not found" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "non_existing_method",
      "params" => %{},
      "id" => "ID"
    }

    error = %MethodNotFound{}
    assert handle(request) == %Response{version: "2.0", id: "ID", error: error, valid?: false}
  end

  test "parse error" do
    request = "not a proper request"

    error = %ParseError{}
    assert handle(request) == %Response{error: error, valid?: false}
  end

  test "server error" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "server_error",
      "params" => %{},
      "id" => "ID"
    }

    error = %ServerError{}
    assert handle(request) == %Response{version: "2.0", id: "ID", error: error, valid?: false}
  end

  test "non-empty list of requests" do
    requests = [
      %{
        "jsonrpc" => "2.0",
        "method" => "hello",
        "params" => %{"name" => "Ron"},
        "id" => "ID1"
      },
      %{
        "jsonrpc" => "2.0",
        "method" => "without_schema_ref",
        "params" => %{"p" => "value"},
        "id" => "ID2"
      }
    ]

    expected_responses = [
      %Response{version: "2.0", data: "Hello, Ron", id: "ID1", valid?: true},
      %Response{version: "2.0", data: "no validation provided", id: "ID2", valid?: true}
    ]

    list_of_responses = handle(requests)

    Enum.each(list_of_responses, fn response ->
      assert response in expected_responses
    end)
  end

  test "empty list of requests" do
    requests = responses = []
    assert handle(requests) === responses
  end

  test "batch limit exceeded" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => %{"name" => "Ron"},
      "id" => "ID"
    }

    requests = 1..100 |> Enum.map(fn _index -> request end)
    expected_error = %InternalError{message: "Batch size limit exceeded."}

    assert handle(requests) === %Response{error: expected_error, valid?: false}
  end
end
