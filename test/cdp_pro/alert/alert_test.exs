defmodule CdpPro.AlertTest do
  use CdpPro.DataCase

  alias CdpPro.Alert

  describe "subscriptions" do
    alias CdpPro.Alert.Subscription

    @create_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => 50}
    @update_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => 100}
    @invalid_attrs %{"cdp_id" => 42, "email" => "someone@example.com", "warn_ratio" => ""}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@create_attrs)
        |> Alert.create_or_update_subscription()

      subscription
    end

    def enabled_subscription_fixture() do
      subscription = subscription_fixture(@create_attrs)
      Alert.update_subscription_status(subscription.id, true)
    end

    test "create_or_update_subscription/1 with valid params creates a subscription" do
      assert {:ok, %Subscription{} = subscription} =
               Alert.create_or_update_subscription(@create_attrs)

      assert subscription.cdp_id == @create_attrs["cdp_id"]
      assert subscription.email == @create_attrs["email"]
      assert subscription.warn_ratio == @create_attrs["warn_ratio"]
    end

    test "create_or_update_subscription/1 with invalid params returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Alert.create_or_update_subscription(@invalid_attrs)
    end

    test "create_or_update_subscription/1 with valid params updates an existing subscription" do
      existing_subscription = subscription_fixture()

      assert {:ok, %Subscription{} = subscription} =
               Alert.create_or_update_subscription(@update_attrs)

      assert subscription.cdp_id == existing_subscription.cdp_id
      assert subscription.email == existing_subscription.email
      assert subscription.warn_ratio == @update_attrs["warn_ratio"]
    end

    test "update_subscription_status/2 with valid data can enable new subscription" do
      subscription = subscription_fixture()

      assert {:ok, %Subscription{} = subscription} =
               Alert.update_subscription_status(subscription.id, true)

      assert subscription.enabled == true
    end

    test "update_subscription_status/2 with valid data can disable enabled subscription" do
      subscription = subscription_fixture()

      assert {:ok, %Subscription{} = subscription} =
               Alert.update_subscription_status(subscription.id, false)

      assert subscription.enabled == false
    end

    test "update_subscription_status/2 with invalid data returns an error" do
      subscription = subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Alert.update_subscription_status(subscription.id, "invalid")
    end
  end
end
