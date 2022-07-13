defmodule PhxJsonRpc.Error do
  @moduledoc """
  An abstract json rpc error.
  """
  defmacro __using__(opts) do
    message = Keyword.fetch!(opts, :message)
    code = Keyword.fetch!(opts, :code)

    quote do
      import unquote(__MODULE__)

      defexception [:data, message: unquote(message), code: unquote(code)]

      @typedoc """
      Type that represents error struct with :code and :message required.
      """
      @type t :: %__MODULE__{
              message: binary(),
              code: integer()
            }

      @spec message(t) :: binary()
      def message(exception) do
        inspect(exception)
      end
    end
  end
end
