defmodule CdpPro.Email do
  import Bamboo.Email

  alias CdpProWeb.Router.Helpers, as: Routes

  def confirm_subscription_email(conn, id) do
    text = "Please confirm your subscription to CDP PRO notifications by clicking on the following link: "
    url = Routes.subscription_path(conn, :confirm, %{id: id})
    new_email(
      to: "john@gmail.com",
      from: "support@mainframe.com",
      subject: "Confirm your subscription to CDP PRO alerts",
      html_body: "<p>#{text} <a href='#{url}'><strong>Confirm Subscription</strong><a></p>",
      text_body: text <> url
    )
  end
end
