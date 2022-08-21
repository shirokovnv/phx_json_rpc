# PhxJsonRpc

![ci.yml][link-ci]
![hex.pm badge][hex-link]

Simple implementation of JSON-RPC server, written in [elixir][elixir-link] and working with [phoenix][phoenix-link].

Allows you to define any number of rpc endpoints, which can be accessed via http protocol.

## How it works

The package uses router `macro` for matching RPC calls to your end-user service.

It uses `JSON SCHEMA` as a specification for your services and provides parsing, validation and error handling briefly.

Requests can be served in batches with asyncronous order.

For usage with phoenix see this [guide][guide-link].

## Installation

The package can be installed
by adding `phx_json_rpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_json_rpc, "~> 0.3.6"}
  ]
end
```

This package depends on [ex_json_schema](https://github.com/jonasschmidt/ex_json_schema) for validation purposes.

## Supported phoenix versions

The package tested with `phoenix >= 1.6`, but probably will work with any version started from `1.4`.

## Documentation

The docs can be found at [https://hexdocs.pm/phx_json_rpc][docs-link].

## Links

The package creation was inspired by some other repos:

- [json-rpc-laravel](https://github.com/avto-dev/json-rpc-laravel)
- [open-rpc](https://github.com/open-rpc/)
- [phoenix1.4-json-rpc](https://github.com/vruizext/phoenix1.4-json-rpc)

## License

MIT. Please see the [license file](LICENSE.md) for more information.

[link-ci]: https://github.com/shirokovnv/phx_json_rpc/actions/workflows/ci.yml/badge.svg
[elixir-link]: https://elixir-lang.org/
[phoenix-link]: https://www.phoenixframework.org/
[guide-link]: https://hexdocs.pm/phx_json_rpc/PhxJsonRpc.html
[docs-link]: https://hexdocs.pm/phx_json_rpc
[hex-link]: https://img.shields.io/hexpm/v/phx_json_rpc