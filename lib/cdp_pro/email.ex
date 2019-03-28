defmodule CdpPro.Email do
  use Bamboo.Phoenix, view: CdpProWeb.EmailView
  import Bamboo.Email

  alias CdpProWeb.Router.Helpers, as: Routes

  def confirm_subscription_email(subscription) do
    new_email(from: "cdp-pro-alerts@mainframe.com")
    |> to(subscription.email)
    |> put_text_layout({CdpProWeb.LayoutView, "email.text"})
    |> put_html_layout({CdpProWeb.LayoutView, "email.html"})
    |> subject("Confirm your subscription to CDP PRO alerts")
    |> render(:text_and_html_email)
  end
end
