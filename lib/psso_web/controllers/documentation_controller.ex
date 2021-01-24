defmodule PssoWeb.DocumentationController do
  use PssoWeb, :controller

  def doc(conn, _params) do
    conn
    |> assign(:page_title, "API Docs")
    |> render("doc.html")
  end
end
