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
  {:phx_json_rpc, "~> 0.3.1"}
  ```

  ## Usage with phoenix

  1. Prepare your service specification, written as JSON SCHEMA

      The bunch of examples can be found [here](https://github.com/open-rpc/examples).

      Usually it should be stored as a dependency or just a file in your repo (for ex `myapp/priv/static/openrpc.json`).

  2. Configure rpc router, specifying json schema version and batch size params

  ```
  defmodule MyApp.Rpc.Router do
    use PhxJsonRpc.Router,
      otp_app: :rpc_router,
      schema: "[PATH_TO_YOUR_SCHEMA]",
      version: "2.0",
      max_batch_size: 20

    alias MyAppRpc.PetController

    ## Pet's service
    rpc("pet.create", PetController, :create, "#/components/schemas/Pet")
    rpc("pet.list", PetController, :list, "#/components/schemas/Pets")
    rpc("pet.update", PetController, :update, "#/components/schemas/Pet")
    rpc("pet.delete", PetController, :delete, "#/components/schemas/PetId")
  end
  ```

  3. Specify service module

  ```
  defmodule MyAppRpc.PetController do
    @moduledoc "My Pet Service"

    def create(%{"name" => name}) do
      "Created"
    end

    def list(_params) do
      [
        "Cat",
        "Dog"
      ]
    end

    def update(params) do
      "Update your pet here"
    end

    def delete(%{"id" => id}) do
      "Pet removed from the store"
    end
  end
  ```

  4. Create controller for handling requests via http

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

  5. Import helpers inside your view and define render function

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

  6. Add endpoint path to your phoenix router under the `api` scope

  ```
  scope "/api", MyAppWeb do
    pipe_through :api

    post("/rpc", RpcController, :rpc)
  end
  ```

  7. Start phoenix server and make an http request

  ```
  curl -X POST \
     -H 'Content-Type:application/json' \
     -d '{"jsonrpc":"2.0","id":"[ID]","method":"pet.create","params":{"name":"Kitty"}}' \
     http://localhost:4000/api/rpc
  ```

  """
end
