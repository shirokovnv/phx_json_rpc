defmodule PhxJsonRpc do
  @moduledoc """
  A simple implementation of the [JSON-RPC](https://www.jsonrpc.org/specification).

  JSON-RPC is a remote procedure call protocol encoded in JSON.
  It is similar to the XML-RPC protocol, defining only a few data types and commands.

  JSON-RPC allows for notifications (data sent to the server that does not require a response)
  and for multiple calls to be sent to the server which may be answered asynchronously.

  ## Getting started

  Add `:phx_json_rpc` to your dependencies

  ```
  {:phx_json_rpc, "~> 0.1.0"}
  ```

  ## Usage with phoenix

  1. Configure rpc router, specifying json schema and version params

  ```
  defmodule MyApp.Rpc.Router do
    use PhxJsonRpc.Router,
      schema: "[PATH_TO_YOUR_SCHEMA]",
      version: "2.0"

    ## Pet's service
    rpc("pet.create", PetController, :create, "#/components/schemas/Pet")
    rpc("pet.list", PetController, :list, "#/components/schemas/Pets")
    rpc("pet.update", PetController, :update, "#/components/schemas/Pet")
    rpc("pet.delete", PetController, :delete, "#/components/schemas/PetId")
  end
  ```

  2. Create controller for handling requests via http

  ```
  defmodule MyAppWeb.RpcController do
    use MyAppWeb, :controller

    alias MyApp.Rpc.Router

    def rpc(conn, request) do
      response = Router.handle(request)
      render(conn, "response.json", response)
    end
  end
  ```

  3. Import helpers inside your view and define render function

  ```
  defmodule MyAppWeb.RpcView do
    use MyAppWeb, :view

    import PhxJsonRpc.Views.Helpers

    def render("response.json", %{response: response}) do
      render_json(response)
    end
  end
  ```

  Optionally, you can `import PhxJsonRpc.Views.Helpers` inside the `view_helpers` quote block in your `web.ex` like so:

  ```
    defp view_helpers do
      quote do
        ...

        import PhxJsonRpcWeb.Views.Helpers
      end
    end
  ```

  4. Add endpoint path to your router under the `api` scope

  ```
  scope "/api", MyAppWeb do
    pipe_through :api

    post("/rpc", RpcController, :rpc)
  end
  ```

  5. Start phoenix server and make an http request

  ```
  curl -X POST \
     -H 'Content-Type:application/json' \
     -d '{"jsonrpc":"2.0","id":"[ID]","method":"pet.create","params":{"name":"Kitty"}}' \
     http://localhost:4000/api/rpc
  ```

  """
end
