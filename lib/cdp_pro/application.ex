defmodule CdpPro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      %{
        id: ExW3.Contract,
        start: {ExW3.Contract, :start_link, []}
      },
      CdpPro.Repo,
      CdpProWeb.Endpoint,
      CdpPro.Worker,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CdpPro.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)
    init_contracts()
    {:ok, pid}
  end

  def init_contracts() do
    tub_abi = ExW3.load_abi("abis/sai_tub.json")
    tub_contract_address = Application.get_env(:ethereumex, :tub_contract_address)

    ExW3.Contract.register(:Tub, abi: tub_abi)
    ExW3.Contract.at(:Tub, tub_contract_address)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CdpProWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
