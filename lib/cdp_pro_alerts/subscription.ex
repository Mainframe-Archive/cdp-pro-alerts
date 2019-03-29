defmodule CdpProAlerts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :cdp_id, :integer
    field :email, :string
    field :warn_ratio, :integer

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:id, :email, :cdp_id, :warn_ratio])
    |> validate_required([:id, :email, :cdp_id, :warn_ratio])
  end
end
