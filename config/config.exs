# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cdp_pro,
  ecto_repos: [CdpPro.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :cdp_pro, CdpProWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: CdpProWeb.ErrorView, accepts: ~w(json html)],
  pubsub: [name: CdpPro.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures ExW3 library
config :ethereumex,
  client_type: :http,
  tub_contract_address: System.get_env("TUB_CONTRACT_ADDRESS"),
  url: "https://mainnet.infura.io/" <> System.get_env("INFURA_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
