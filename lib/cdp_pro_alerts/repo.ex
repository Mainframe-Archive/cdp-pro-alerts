defmodule CdpProAlerts.Repo do
  use Ecto.Repo,
    otp_app: :cdp_pro_alerts,
    adapter: Ecto.Adapters.Postgres
end
