defmodule PssoWeb.DocumentationController do
  use PssoWeb, :controller

  def doc(conn, _params) do
    render(conn, "doc.html")
  end
end
