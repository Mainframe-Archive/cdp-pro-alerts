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

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{source: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription) do
    Subscription.changeset(subscription, %{})
  end
end
