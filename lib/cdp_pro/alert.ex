defmodule CdpPro.Alert do
  @moduledoc """
  The Alert context.
  """

  import Ecto.Query, warn: false
  alias CdpPro.Repo
  alias CdpPro.Alert.Subscription

  # TODO: update docs
  @doc false
  def create_or_update_subscription(%{"cdp_id" => cdp_id, "email" => email} = attrs) do
    case Repo.get_by(Subscription, %{cdp_id: cdp_id, email: email}) do
      nil -> %Subscription{}
      subscription -> subscription
    end
    |> Subscription.changeset(attrs)
    |> Repo.insert_or_update
  end

  def create_or_update_subscription(_) do
    {:error, :invalid_params}
  end

  # TODO: update docs
  @doc false
  def enable_subscription(id) do
    Repo.get(Subscription, id)
    case Repo.get(Subscription, id) do
      nil ->
        {:error, :subscription_not_found}
      subscription ->
        subscription
        |> Subscription.changeset(%{enabled: true})
        |> Repo.update
    end
  end

  # TODO: update docs
  @doc false
  def disable_subscription(id) do
    Repo.get(Subscription, id)
    case Repo.get(Subscription, id) do
      nil ->
        {:error, :subscription_not_found}
      subscription ->
        enabled_subscription = subscription
        |> Subscription.changeset(%{enabled: false})
        |> Repo.update
        {:ok, enabled_subscription}
    end
  end
end
