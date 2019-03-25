defmodule CdpPro.AlertTest do
  use CdpPro.DataCase

  alias CdpPro.Alert

  describe "subscriptions" do
    alias CdpPro.Alert.Subscription

    @valid_attrs %{cdp_id: 42, email: "some email", warn_ratio: 42}
    @update_attrs %{cdp_id: 43, email: "some updated email", warn_ratio: 43}
    @invalid_attrs %{cdp_id: nil, email: nil, warn_ratio: nil}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Alert.create_subscription()

      subscription
    end

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Alert.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Alert.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Alert.create_subscription(@valid_attrs)
      assert subscription.cdp_id == 42
      assert subscription.email == "some email"
      assert subscription.warn_ratio == 42
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Alert.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{} = subscription} = Alert.update_subscription(subscription, @update_attrs)
      assert subscription.cdp_id == 43
      assert subscription.email == "some updated email"
      assert subscription.warn_ratio == 43
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Alert.update_subscription(subscription, @invalid_attrs)
      assert subscription == Alert.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Alert.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Alert.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Alert.change_subscription(subscription)
    end
  end
end
