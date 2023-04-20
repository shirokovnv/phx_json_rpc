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

  If batch size exceeded, an exception will be rendered and
  requests for the current batch wont be processed.
  """
  @callback handle(request :: list(map()) | map(), context :: module()) ::
              [Response.t()] | Response.t()
end

defmodule PhxJsonRpc.Router.DefaultPipe do
  @moduledoc false

  @behaviour PhxJsonRpc.Router.Pipe

  alias PhxJsonRpc.Error.InternalError
  alias PhxJsonRpc.Response
  alias PhxJsonRpc.Router.{DefaultDispatcher, DefaultParser, DefaultValidator}

  @default_parser DefaultParser
  @default_validator DefaultValidator
  @default_dispatcher DefaultDispatcher

  @impl true
  def handle(%{"_json" => requests}, context) do
    handle(requests, context)
  end

  @impl true
  def handle(requests, context) when is_list(requests) do
    if Enum.count(requests) <= context.instance.get_max_batch_size() do
      handle_batch(requests, context)
    else
      show_limit_error()
    end
  end

  @impl true
  def handle(request, context) do
    meta = get_metadata(request, context)
    schema_ref = if is_nil(meta), do: nil, else: meta.schema_ref

    config = Application.get_env(context.instance.get_otp_app(), context, [])
    parser = config[:parser] || @default_parser
    validator = config[:validator] || @default_validator
    dispatcher = config[:dispatcher] || @default_dispatcher

    request
    |> parser.parse(context.instance.get_version())
    |> validator.validate(schema_ref, context.instance.get_json_schema())
    |> dispatcher.dispatch(meta)
  end

  defp handle_batch(requests, context) do
    requests
    |> Task.async_stream(fn request -> handle(request, context) end, ordered: false)
    |> Enum.map(fn {:ok, response} -> response end)
    |> Enum.to_list()
  end

  defp show_limit_error do
    error = %InternalError{message: "Batch size limit exceeded."}
    %Response{error: error, valid?: false}
  end

  defp get_metadata(request, context) when is_map(request) do
    method = Map.get(request, "method")

    if is_binary(method) do
      Keyword.get(context.instance.get_routes(), get_key(method))
    else
      nil
    end
  end

  defp get_metadata(_request, _context), do: nil

  defp get_key(method) do
    String.to_existing_atom(method)
  rescue
    ArgumentError -> nil
  end
end
