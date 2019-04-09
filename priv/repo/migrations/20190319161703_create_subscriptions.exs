defmodule CdpPro.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  @unix_epoch NaiveDateTime.to_string(~N[1970-01-01 00:00:00.000000])

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cdp_id, :integer
      add :warn_ratio, :integer
      add :email, :string
      add :enabled, :boolean, default: false
      add :last_triggered, :naive_datetime, default: @unix_epoch

      timestamps()
    end

    create unique_index(:subscriptions, [:cdp_id, :email], name: :subscriptions_index)
  end
end
