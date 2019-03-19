defmodule CdpPro.Alert.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "subscriptions" do
    field :cdp_id, :integer
    field :email, :string
    field :warn_ratio, :integer

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:cdp_id, :warn_ratio, :email])
    |> validate_required([:cdp_id, :warn_ratio, :email])
  end
end
