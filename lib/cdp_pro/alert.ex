defmodule CdpPro.Alert do
  @moduledoc """
  The Alert context.
  """

  @unix_epoch NaiveDateTime.to_string(~N[1970-01-01 00:00:00.000000])

  import Ecto.Query, warn: false
  alias CdpPro.Repo
  alias CdpPro.Alert.Subscription

  @spec get_all_active_subscriptions() :: {:ok, [%Subscription{}]}

  def get_all_active_subscriptions() do
    Subscription
    |> where([sub], sub.enabled)
    |> Repo.all()
  end

  # TODO: update docs
  @doc false
  @spec create_or_update_subscription(map) ::
          {:ok, %Subscription{}} | {:error, :invalid_params} | {:error, %Ecto.Changeset{}}

  def create_or_update_subscription(%{"cdp_id" => cdp_id, "email" => email} = attrs) do
    attrs = Map.put_new(attrs, "last_triggered", @unix_epoch)

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
  @spec update_subscription_status(Ecto.UUID, boolean) ::
          {:ok, %Subscription{}} | {:error, :subscription_not_found} | {:error, %Ecto.Changeset{}}

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
  @spec update_last_triggered_time(Ecto.UUID, %NaiveDateTime{}) ::
          {:ok, %Subscription{}} | {:error, :subscription_not_found} | {:error, %Ecto.Changeset{}}

  def update_last_triggered_time(id, time) do
    Repo.get(Subscription, id)
    |> Subscription.changeset(%{last_triggered: time})
    |> Repo.update()
  end
end
