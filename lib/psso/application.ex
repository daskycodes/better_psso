defmodule Psso.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PssoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Psso.PubSub},
      # Start the Endpoint (http/https)
      PssoWeb.Endpoint
      # Start a worker by calling: Psso.Worker.start_link(arg)
      # {Psso.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Psso.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PssoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
