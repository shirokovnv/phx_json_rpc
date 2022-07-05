defmodule PhxJsonRpc.Router.SchemaResolverTest do
  use ExUnit.Case
  alias PhxJsonRpc.Router.SchemaResolver

  test "resolves existing file" do
    schema = SchemaResolver.resolve("priv/static/openrpc.json")
    assert schema.__struct__ === ExJsonSchema.Schema.Root
  end

  test "raises error on resolving non-existing file" do
    assert_raise File.Error, fn ->
      SchemaResolver.resolve("non-existing-schema.json")
    end
  end
end
