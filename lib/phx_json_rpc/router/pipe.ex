defmodule PhxJsonRpc.Router.Pipe do
  @moduledoc """
  Behaviour for handling requests via rpc.
  """
  alias PhxJsonRpc.Response

  @doc """
  Handles rpc requests via the given context(router).

  Processes each request by the following pipeline:
  ```
  - parse
  - validate
  - dispatch
  ```
  """
  @callback handle(request :: list(map()) | map(), context :: module()) ::
              [Response.t()] | Response.t()
end

defmodule PhxJsonRpc.Router.DefaultPipe do
  @moduledoc false

  @behaviour PhxJsonRpc.Router.Pipe

  alias PhxJsonRpc.Router.{DefaultParser, DefaultValidator, DefaultDispatcher}

  @impl true
  def handle(%{"_json" => requests}, context) do
    handle(requests, context)
  end

  @impl true
  def handle(requests, context) when is_list(requests) do
    requests
    |> Task.async_stream(fn request -> handle(request, context) end, ordered: false)
    |> Enum.map(fn {:ok, response} -> response end)
    |> Enum.to_list()
  end

  @impl true
  def handle(request, context) do
    meta = get_metadata(request, context)
    schema_ref = if is_nil(meta), do: nil, else: meta.schema_ref

    request
    |> DefaultParser.parse(context.get_version())
    |> DefaultValidator.validate(schema_ref, context.get_json_schema())
    |> DefaultDispatcher.dispatch(meta)
  end

  defp get_metadata(request, context) when is_map(request) do
    method = Map.get(request, "method")

    if is_binary(method) do
      Keyword.get(context.get_routes(), get_key(method))
    else
      nil
    end
  end

  defp get_metadata(_request, _context), do: nil

  defp get_key(method) do
    try do
      String.to_existing_atom(method)
    rescue
      ArgumentError -> nil
    end
  end
end
