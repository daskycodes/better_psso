defmodule PssoWeb.PageLiveTest do
  use PssoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Better PSSO"
    assert render(page_live) =~ "Better PSSO"
  end
end
