defmodule PhxJsonRpcWeb.Views.Helpers do
  @moduledoc """
  Helper module provides a set of `render` functions for the phoenix views.
  """

  alias PhxJsonRpc.Response

  @doc """
    Renders json rpc responses.

    ## Examples

      iex> PhxJsonRpcWeb.Views.Helpers.render_json([
      ...>%PhxJsonRpc.Response{version: "2.0", id: "ID1", data: %{name: "Ron"}, valid?: true},
      ...>%PhxJsonRpc.Response{version: "2.0", id: "ID2", error: %PhxJsonRpc.Error.ServerError{
      ...>code: -32000, message: "Server error"}, valid?: false}])
      [
        %{"id" => "ID1", "jsonrpc" => "2.0", "result" => %{name: "Ron"}},
        %{"error" => %{
          "code" => -32000,
          "data" => nil,
          "message" => "Server error"
          },
          "id" => "ID2",
          "jsonrpc" => "2.0"
        }
      ]

      iex> PhxJsonRpcWeb.Views.Helpers.render_json(
      ...>%PhxJsonRpc.Response{
      ...>version: "2.0",
      ...>id: "ID",
      ...>data: %{name: "Ron"},
      ...>valid?: true}
      ...>)
      %{"id" => "ID", "jsonrpc" => "2.0", "result" => %{name: "Ron"}}

  """
  @spec render_json(response :: list(Response.t()) | Response.t()) :: list(map()) | map()
  def render_json(response) when is_list(response) do
    response
    |> Enum.map(fn element -> render_json(element) end)
    |> Enum.to_list()
  end

  def render_json(%Response{valid?: true} = response) do
    %{
      "jsonrpc" => response.version,
      "result" => response.data,
      "id" => response.id
    }
  end

  def render_json(%Response{valid?: false, error: error} = response) do
    %{
      "jsonrpc" => response.version,
      "error" => %{
        "data" => Map.get(error || %{}, :data),
        "code" => Map.get(error || %{}, :code),
        "message" => Map.get(error || %{}, :message)
      },
      "id" => response.id
    }
  end
end
