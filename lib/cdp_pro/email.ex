defmodule CdpPro.Email do
  use Bamboo.Phoenix, view: CdpProWeb.EmailView
  import Bamboo.Email
  alias CdpProWeb.Router.Helpers, as: Routes

  @from_email Application.get_env(:cdp_pro, :subscriptions_email)

  def confirm_subscription_email(subscription) do
    new_email()
    |> from(@from_email)
    |> to(subscription.email)
    |> put_layout({CdpProWeb.LayoutView, :email})
    |> subject("Confirm your subscription to CDP PRO alerts")
    |> render(:text_and_html_email)
  end

  def warning_email(subscription) do
    new_email()
    |> from(@from_email)
    |> to(subscription.email)
    |> put_layout({CdpProWeb.LayoutView, :email})
    |> text_body("Welcome")
    |> subject("CDP PRO alert: Your collateralization ratio has reached the CDP Guard limit")
  end
end
