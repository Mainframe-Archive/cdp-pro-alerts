defmodule CdpPro.Repo do
  use Ecto.Repo,
    otp_app: :cdp_pro,
    adapter: Ecto.Adapters.Postgres
end
