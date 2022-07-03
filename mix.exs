defmodule PhxJsonRpc.MixProject do
  use Mix.Project

  alias PhxJsonRpc.Types
  alias PhxJsonRpc.{Request, Response, Router}

  alias PhxJsonRpc.Router.{
    Context,
    Parser,
    Validator,
    Dispatcher,
    MetaData,
    SchemaResolver,
    Pipe
  }

  alias PhxJsonRpc.Error

  alias PhxJsonRpc.Error.{
    InternalError,
    InvalidParams,
    InvalidRequest,
    MethodNotFound,
    ParseError,
    ServerError
  }

  alias PhxJsonRpcWeb.Views.Helpers

  @url "https://github.com/shirokovnv/phx_json_rpc"

  def project do
    [
      app: :phx_json_rpc,
      version: "0.1.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Phoenix JSON RPC",
      source_url: @url,
      homepage_url: @url,
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      description: "A simple implementation of JSON-RPC server",
      licenses: ["MIT"],
      maintainers: ["Nickolai Shirokov (shirokovnv@gmail.com)"],
      links: %{
        "Changelog" => "https://hexdocs.pm/phx_json_rpc/changelog.html",
        "Github" => @url
      }
    ]
  end

  defp docs do
    [
      main: "PhxJsonRpc",
      extras: [
        "README.md": [title: "Overview"],
        "LICENSE.md": [title: "License"],
        "CHANGELOG.md": [title: "Changelog"]
      ],
      groups_for_modules: [
        Types: [Types, Request, Response, MetaData],
        Router: [
          Router,
          Context,
          Parser,
          Validator,
          Dispatcher,
          SchemaResolver,
          Pipe
        ],
        View: [
          Helpers
        ],
        Errors: [
          Error,
          InternalError,
          InvalidParams,
          InvalidRequest,
          MethodNotFound,
          ParseError,
          ServerError
        ]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:ex_json_schema, "~> 0.9.1"}
    ]
  end
end
