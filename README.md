# PhxJsonRpc

Simple implementation of JSON-RPC server, working with phoenix.

Allows you to define any number of rpc endpoints, with simple access via http protocol.

Endpoint can handle batches in asyncronous order.

## Installation

The package can be installed
by adding `phx_json_rpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_json_rpc, "~> 0.1.0"}
  ]
end
```

This package depends on [ex_json_schema](https://github.com/jonasschmidt/ex_json_schema) for validation purposes.

## Quick start

Please see this [guide](https://hexdocs.pm/phx_json_rpc/PhxJsonRpc.html) for usage with phoenix.

## Documentation

The docs can be found at [https://hexdocs.pm/phx_json_rpc](https://hexdocs.pm/phx_json_rpc).

## Links

The package creation was inspired by some other repos:

- [json-rpc-laravel](https://github.com/avto-dev/json-rpc-laravel)
- [open-rpc](https://github.com/open-rpc/)
- [phoenix1.4-json-rpc](https://github.com/vruizext/phoenix1.4-json-rpc)

## License

MIT. Please see the [license file](LICENSE.md) for more information.
