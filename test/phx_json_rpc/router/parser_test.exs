defmodule PhxJsonRpc.Router.ParserTest do
  use ExUnit.Case
  alias PhxJsonRpc.Router.DefaultParser
  alias PhxJsonRpc.Request
  alias PhxJsonRpc.Error.ParseError

  test "parses valid request" do
    request = %{
      "jsonrpc" => "2.0",
      "method" => "hello",
      "params" => [],
      "id" => "ID"
    }

    assert DefaultParser.parse(request, "2.0") === %Request{
             version: "2.0",
             method: "hello",
             id: "ID",
             params: [],
             valid?: true
           }
  end

  test "parses not valid request" do
    request = "not a valid request"
    error = %ParseError{}

    assert DefaultParser.parse(request, "2.0") === %Request{
             valid?: false,
             error: error
           }
  end
end
