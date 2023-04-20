defmodule PhxJsonRpc.Router.Dispatcher do
  @moduledoc """
  Behaviour for the rpc requests dispatcher.
  """
  alias PhxJsonRpc.{Request, Response}
  alias PhxJsonRpc.Router.MetaData

  @doc """
  Dispatches the given rpc request, using module and action definitions in metadata.

  If no metadata specified, falls to `method not found` response.
  """
  @callback dispatch(request :: Request.t(), meta :: nil | MetaData.t()) :: Response.t()
end

defmodule PhxJsonRpc.Router.DefaultDispatcher do
  @moduledoc false

  @behaviour PhxJsonRpc.Router.Dispatcher

  alias PhxJsonRpc.Error.{
    InternalError,
    InvalidParams,
    InvalidRequest,
    MethodNotFound,
    ParseError,
    ServerError
  }

  alias PhxJsonRpc.Logger
  alias PhxJsonRpc.Response
  alias PhxJsonRpc.Router.MetaData

  @impl true
  def dispatch(%PhxJsonRpc.Request{valid?: true} = request, meta) when is_nil(meta) do
    with_error(%MethodNotFound{}, request.id, request.version)
  end

  @impl true
  def dispatch(%PhxJsonRpc.Request{valid?: false} = request, _meta) do
    with_error(request.error, request.id, request.version)
  end

  @impl true
  def dispatch(%PhxJsonRpc.Request{params: params, id: id, version: version}, %MetaData{} = meta) do
    with_result(
      apply(meta.controller, meta.action, [params]),
      id,
      version
    )
  rescue
    e in [
      InternalError,
      InvalidParams,
      InvalidRequest,
      MethodNotFound,
      ParseError,
      ServerError
    ] ->
      with_error(e, id, version, e, __STACKTRACE__)

    e in FunctionClauseError ->
      with_error(%InvalidParams{}, id, version, e, __STACKTRACE__)

    e in [ArgumentError, UndefinedFunctionError] ->
      with_error(%MethodNotFound{}, id, version, e, __STACKTRACE__)

    e ->
      with_error(%InternalError{}, id, version, e, __STACKTRACE__)
  end

  defp with_result(result, id, version) do
    Response.new(data: result, id: id, valid?: true, version: version)
  end

  defp with_error(error, id, version, should_be_logged_error \\ nil, stacktrace \\ nil) do
    if should_be_logged_error do
      Logger.log_error(id, should_be_logged_error, stacktrace)
    end

    Response.new(id: id, valid?: false, error: error, version: version)
  end
end
