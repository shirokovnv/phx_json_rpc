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

  require Logger

  alias PhxJsonRpc.Router.MetaData
  alias PhxJsonRpc.Response

  alias PhxJsonRpc.Error.{
    InternalError,
    InvalidParams,
    InvalidRequest,
    MethodNotFound,
    ParseError,
    ServerError
  }

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
    try do
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
        log_exception(e, __STACKTRACE__)
        with_error(e, id, version)

      e in FunctionClauseError ->
        log_exception(e, __STACKTRACE__)
        with_error(%InvalidParams{}, id, version)

      e in [ArgumentError, UndefinedFunctionError] ->
        log_exception(e, __STACKTRACE__)
        with_error(%MethodNotFound{}, id, version)

      e ->
        log_exception(e, __STACKTRACE__)
        with_error(%InternalError{}, id, version)
    end
  end

  defp log_exception(exception, stacktrace) do
    Logger.error(Exception.format(:error, exception, stacktrace))
  end

  defp with_result(result, id, version) do
    Response.new(data: result, id: id, valid?: true, version: version)
  end

  defp with_error(error, id, version) do
    Response.new(id: id, valid?: false, error: error, version: version)
  end
end
