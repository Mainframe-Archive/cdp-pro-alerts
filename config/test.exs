use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cdp_pro, CdpProWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cdp_pro, CdpPro.Repo,
  username: "postgres",
  password: "postgres",
  database: "cdp_pro_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :cdp_pro, CdpPro.Mailer, adapter: Bamboo.TestAdapter
