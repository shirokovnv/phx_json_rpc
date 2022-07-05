defmodule PhxJsonRpc.Router.ValidatorTest do
  use ExUnit.Case
  alias PhxJsonRpc.Error.InvalidParams
  alias PhxJsonRpc.Router.{DefaultValidator, SchemaResolver}
  alias PhxJsonRpc.Request

  setup_all do
    schema_ref = "#/components/schemas/Name"
    schema = SchemaResolver.resolve("priv/static/openrpc.json")
    [schema_ref: schema_ref, schema: schema]
  end

  test "passes validation", state do
    params = %{"name" => "Ron"}
    request = %Request{method: "hello", id: "ID", params: params, valid?: true}

    schema_ref = state[:schema_ref]
    schema = state[:schema]

    assert DefaultValidator.validate(request, schema_ref, schema) ===
             %Request{method: "hello", params: params, id: "ID", valid?: true}
  end

  test "doesn't pass validation", state do
    params = %{"name" => 10, "age" => "Ron"}
    request = %Request{method: "hello", id: "ID", params: params, valid?: true}

    schema_ref = state[:schema_ref]
    schema = state[:schema]

    expected_error = %InvalidParams{
      data: [
        {"Type mismatch. Expected String but got Integer.", "#/name"},
        {"Schema does not allow additional properties.", "#/age"}
      ]
    }

    assert DefaultValidator.validate(request, schema_ref, schema) ===
             %Request{
               method: "hello",
               params: params,
               id: "ID",
               valid?: false,
               error: expected_error
             }
  end
end
