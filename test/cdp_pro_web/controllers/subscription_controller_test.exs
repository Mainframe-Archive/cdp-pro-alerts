defmodule CdpProWeb.SubscriptionControllerTest do
  use CdpProWeb.ConnCase

  alias CdpPro.Alert

  @create_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => 50}
  @update_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => 100}
  @invalid_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => ""}
  @random_id Ecto.UUID.generate

  def fixture(:new_subscription) do
    {:ok, subscription} = Alert.create_or_update_subscription(@create_attrs)
    subscription
  end

  def fixture(:enabled_subscription) do
    {:ok, subscription} = Alert.create_or_update_subscription(@create_attrs)
    {:ok, subscription} = Alert.update_subscription_status(subscription.id, true)
    subscription
  end

  describe "create or update subscription" do
    test "returns a 200 when creating with valid params", %{conn: conn} do
      conn = post(conn, Routes.subscription_path(conn, :create), @create_attrs)

      assert json_response(conn, 200) == %{"status" => "success"}
    end

    test "returns a 200 when updating with valid params", %{conn: conn} do
      conn = post(conn, Routes.subscription_path(conn, :create), @update_attrs)

      assert json_response(conn, 200) == %{"status" => "success"}
    end

    test "returns an error when params are completely invalid", %{conn: conn} do
      conn = post(conn, Routes.subscription_path(conn, :create), subscription: @invalid_attrs)
      assert json_response(conn, 400) == %{"errors" => "Params are invalid", "status" => "failure"}
    end

    test "returns a more specific error when correct param keys have invalid values", %{conn: conn} do
      conn = post(conn, Routes.subscription_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 400) == %{"errors" => %{"warn_ratio" => ["can't be blank"]}, "status" => "failure"}
    end
  end


  describe "confirm subscription or unsubscribe" do
    test "valid id successfully confirms subscription", %{conn: conn} do
      subscription = fixture(:new_subscription)
      conn = get(conn, Routes.subscription_path(conn, :confirm), %{"id" => subscription.id})

      assert html_response(conn, 200) =~ "successful"
    end

    test "valid id successfully unsubscribes confirmed subscription", %{conn: conn} do
      subscription = fixture(:enabled_subscription)
      conn = get(conn, Routes.subscription_path(conn, :unsubscribe), %{"id" => subscription.id})

      assert html_response(conn, 200) =~ "successful"
    end

    test "invalid id returns an error when trying to confirm subscription", %{conn: conn} do
      conn = get(conn, Routes.subscription_path(conn, :confirm), %{"id" => @random_id})

      assert html_response(conn, 404) =~ "Not Found"
    end

    test "invalid id returns an error when trying to unsubscribe", %{conn: conn} do
      conn = get(conn, Routes.subscription_path(conn, :unsubscribe), %{"id" => @random_id})

      assert html_response(conn, 404) =~ "Not Found"
    end
  end
end
