defmodule CdpProWeb.PageController do
  use CdpProWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(external: "https://mainframe.com/")
    |> halt()
  end
end
