defmodule CdpProWeb.PageController do
  use CdpProWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
