defmodule CdpProWeb.SubscriptionController do
  use CdpProWeb, :controller

  alias CdpPro.Alert
  alias CdpPro.Alert.Subscription
  alias CdpPro.Email
  alias CdpPro.Mailer
  alias CdpProWeb.ErrorView

  def create(conn, subscription_params) do
    case Alert.create_or_update_subscription(subscription_params) do
      {:ok, subscription} ->
        unless subscription.enabled do
          Email.confirm_subscription_email(conn, subscription.id)
          |> Mailer.deliver_later()
        end

        conn
        |> put_status(204)
        |> text("")

      {:error, :invalid_params} ->
        conn
        |> put_status(400)
        |> json(%{errors: "Params are invalid", status: "failure"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> put_status(400)
        |> render("400.json", %{changeset: changeset})
    end
  end

  def confirm(conn, %{"id" => id}) do
    case Alert.enable_subscription(id) do
      {:error, :subscription_not_found} ->
        conn
        |> put_view(ErrorView)
        |> put_status(404)
        |> render("404.html")
      {:ok, subscription} ->
        conn
        |> render("confirm.html", subscription: subscription)
    end
  end

  def unsubscribe(conn, %{"id" => id}) do
    case Alert.disable_subscription(id) do
      {:error, :subscription_not_found} ->
        conn
        |> put_view(ErrorView)
        |> put_status(404)
        |> render("404.html")
      {:ok, subscription} ->
        conn
        |> render("unsubscribe.html", subscription: subscription)
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
