defmodule CdpProWeb.SubscriptionController do
  use CdpProWeb, :controller

  alias CdpPro.Alert
  alias CdpPro.Alert.Subscription
  alias CdpProWeb.ErrorView

  def create(conn, subscription_params) do
    case Alert.create_or_update_subscription(subscription_params) do
      {:ok, subscription} ->
        conn
        |> put_status(204)
        |> text("")

      {:error, :invalid_params} ->
        conn
        |> put_status(400)
        |> json(%{errors: "Params are invalid", status: "failure"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> put_view(ErrorView)
        |> render("400.json", %{changeset: changeset})
    end
  end

  # Scaffolding

  def index(conn, _params) do
    subscriptions = Alert.list_subscriptions()
    render(conn, "index.html", subscriptions: subscriptions)
  end

  def new(conn, _params) do
    changeset = Alert.change_subscription(%Subscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    subscriptions = Alert.list_subscriptions()
    render(conn, "index.html", subscriptions: subscriptions)
  end

  def show(conn, %{"id" => id}) do
    subscription = Alert.get_subscription!(id)
    render(conn, "show.html", subscription: subscription)
  end

  def edit(conn, %{"id" => id}) do
    subscription = Alert.get_subscription!(id)
    changeset = Alert.change_subscription(subscription)
    render(conn, "edit.html", subscription: subscription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Alert.get_subscription!(id)

    case Alert.update_subscription(subscription, subscription_params) do
      {:ok, subscription} ->
        conn
        # |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: Routes.subscription_path(conn, :show, subscription))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", subscription: subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = Alert.get_subscription!(id)
    {:ok, _subscription} = Alert.delete_subscription(subscription)

    conn
    # |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: Routes.subscription_path(conn, :index))
  end
end
