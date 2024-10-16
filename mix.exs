defmodule PhxJsonRpc.MixProject do
  use Mix.Project

  alias PhxJsonRpc.Types
  alias PhxJsonRpc.{Request, Response, Router}

  alias PhxJsonRpc.Router.{
    Context,
    Middleware,
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
      version: "0.7.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "Phoenix JSON RPC",
      source_url: @url,
      homepage_url: @url,
      docs: docs(),
      package: package(),

      # Dialyzer
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:ex_json_schema, :jason]
      ]
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

  defp aliases do
    [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
    File.mkdir("doc/test")

    File.cp_r("test/priv", "doc/test/priv", fn _source, _destination ->
      true
    end)
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
          Middleware,
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test),
    do: ["lib", "test/phx_json_rpc_web/controllers", "test/phx_json_rpc_web/middleware"]

  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30.5", only: :dev, runtime: false},
      {:ex_json_schema, "~> 0.10.1"},
      {:excoveralls, "~> 0.10", only: :test},
      {:jason, "~> 1.4", optional: true}
    ]
  end
end
