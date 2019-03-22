defmodule CdpPro.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cdp_id, :integer
      add :warn_ratio, :integer
      add :email, :string
      add :enabled, :boolean, default: false

      timestamps()
    end

    create unique_index(:subscriptions, [:cdp_id, :email], name: :subscriptions_index)
  end
end
