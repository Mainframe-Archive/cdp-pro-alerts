defmodule CdpPro.Email do
  use Bamboo.Phoenix, view: CdpProWeb.EmailView

  @from_email Application.get_env(:cdp_pro, :subscriptions_email)

  @spec confirm_subscription_email(%CdpPro.Alert.Subscription{}) :: %Bamboo.Email{}

  def confirm_subscription_email(subscription) do
    subscription
    |> base_email()
    |> subject("Confirm your subscription to CDP PRO alerts")
    |> render(:confirm)
  end

  @spec warning_email(%CdpPro.Alert.Subscription{}) :: %Bamboo.Email{}

  def warning_email(subscription) do
    subscription
    |> base_email()
    |> subject("CDP PRO alert: Your collateralization ratio has reached the CDP Guard limit")
    |> render(:warning)
  end

  defp base_email(subscription) do
    new_email()
    |> from(@from_email)
    |> to(subscription.email)
    |> assign(:subscription, subscription)
    |> put_header("Reply-To", @from_email)
    |> put_layout({CdpProWeb.LayoutView, :email})
  end
end
