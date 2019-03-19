defmodule CdpProAlertsWeb.PageController do
  use CdpProAlertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
