defmodule CdpPro.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cdp_id, :integer
      add :warn_ratio, :integer
      add :email, :string

      timestamps()
    end

  end
end
