defmodule PhxJsonRpc.Router.Validator do
  @moduledoc """
  Validation behaviour for the rpc requests.
  """
  alias PhxJsonRpc.Request

  @doc """
  Validates the given rpc request against json-schema provided.

  If validation fails, enriches request with `error` struct and set `valid?` parameter to false.
  """
  @callback validate(request :: Request.t(), schema_ref :: nil | binary(), schema :: map()) ::
              PhxJsonRpc.Request.t()
end

defmodule PhxJsonRpc.Router.DefaultValidator do
  @moduledoc false

  @behaviour PhxJsonRpc.Router.Validator

  alias PhxJsonRpc.Error.InvalidParams

  @impl true
  def validate(%PhxJsonRpc.Request{} = request, schema_ref, _schema) when is_nil(schema_ref),
    do: request

  @impl true
  def validate(%PhxJsonRpc.Request{valid?: false} = request, _schema_ref, _schema), do: request

  @impl true
  def validate(%PhxJsonRpc.Request{params: params} = request, schema_ref, schema) do
    case validate_by_schema(params, schema_ref, schema) do
      :ok ->
        request

      {:error, errors} ->
        error = %InvalidParams{data: errors}

        request
        |> Map.merge(%{error: error, valid?: false})
    end
  end

  defp validate_by_schema(_params, schema_ref, _schema) when is_nil(schema_ref), do: :ok

  defp validate_by_schema(params, schema_ref, schema) do
    case ExJsonSchema.Schema.get_fragment(schema, schema_ref) do
      {:ok, fragment} ->
        ExJsonSchema.Validator.validate_fragment(schema, fragment, params)

      {:error, :invalid_reference} ->
        errors = ["Schema reference #{schema_ref} does not exist."]
        {:error, errors}
    end
  end
end
