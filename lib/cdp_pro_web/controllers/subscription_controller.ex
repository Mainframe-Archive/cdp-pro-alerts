defmodule CdpProWeb.SubscriptionController do
  use CdpProWeb, :controller

  alias CdpPro.Alert
  alias CdpPro.Email
  alias CdpPro.Mailer
  alias CdpProWeb.ErrorView

  def create(conn, subscription_params) do
    case Alert.create_or_update_subscription(subscription_params) do
      {:ok, subscription} ->
        unless subscription.enabled do
          |> Mailer.deliver_later()
          Email.confirm_subscription_email(conn, subscription)
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
    case Alert.update_subscription_status(id, true) do
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
    case Alert.update_subscription_status(id, false) do
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
end
