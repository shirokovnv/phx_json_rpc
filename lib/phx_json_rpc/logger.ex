defmodule PhxJsonRpc.Logger do
  @moduledoc """
  Module represents error logging functions.
  """

  require Logger

  @doc """
    Log exception linked with specific request ID.
  """
  def log_error(request_id, exception, stacktrace) do
    Logger.error(
      Enum.join([
        "Request #{request_id} causes an exception: ",
        Exception.format(:error, exception, stacktrace)
      ])
    )
  end
end
