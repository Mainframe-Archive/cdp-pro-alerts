defmodule CdpProWeb.PageControllerTest do
  use CdpProWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) =~ "https://mainframe.com"
  end
end
