defmodule CdpPro.Alert do
  @moduledoc """
  The Alert context.
  """

  import Ecto.Query, warn: false
  alias CdpPro.Repo
  alias CdpPro.Alert.Subscription

  def get_all_active_subscriptions() do
    Subscription
    |> where([sub], sub.enabled)
    |> Repo.all()
  end

  # TODO: update docs
  @doc false
  def create_or_update_subscription(%{"cdp_id" => cdp_id, "email" => email} = attrs) do
    case Repo.get_by(Subscription, %{cdp_id: cdp_id, email: email}) do
      nil -> %Subscription{}
      subscription -> subscription
    end
    |> Subscription.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def create_or_update_subscription(_) do
    {:error, :invalid_params}
  end

  # TODO: update docs
  @doc false
  def update_subscription_status(id, status) do
    Repo.get(Subscription, id)

    case Repo.get(Subscription, id) do
      nil ->
        {:error, :subscription_not_found}

      subscription ->
        subscription
        |> Subscription.changeset(%{enabled: status})
        |> Repo.update()
    end
  end

  # TODO: update docs
  @doc false
  def update_last_triggered_time(id, time) do
    Repo.get(Subscription, id)
    |> Subscription.changeset(%{last_triggered: time})
    |> Repo.update()
  end
end
