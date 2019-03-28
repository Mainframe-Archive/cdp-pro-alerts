defmodule CdpPro.Email do
  import Bamboo.Email

  alias CdpProWeb.Router.Helpers, as: Routes

  def confirm_subscription_email(subscription) do
    new_email(from: "cdp-pro-alerts@mainframe.com")
    |> to(subscription.email)
    |> put_html_layout({CdpProWeb.LayoutView, "email.html"})
    |> subject("Confirm your subscription to CDP PRO alerts")
    |> render("email.html")
  end
end
