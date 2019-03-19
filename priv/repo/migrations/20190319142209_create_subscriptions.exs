defmodule CdpProAlerts.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :email, :string
      add :cdp_id, :integer
      add :warn_ratio, :integer

      timestamps()
    end

  end
end
