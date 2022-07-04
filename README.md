# PhxJsonRpc

Simple implementation of JSON-RPC server, working with [phoenix](https://www.phoenixframework.org/).

Allows you to define any number of rpc endpoints, which can be accessed via http protocol.

## How it works

The package uses router `macro` for matching RPC calls to your end-user service.

It uses `JSON SCHEMA` as a specification for your services and provides parsing, validation and error handling briefly.

Requests can be served in batches with asyncronous order.

See documentation section for more detail.

## Installation

The package can be installed
by adding `phx_json_rpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_json_rpc, "~> 0.3.1"}
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
