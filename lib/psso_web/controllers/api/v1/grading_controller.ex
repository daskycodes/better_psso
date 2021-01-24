defmodule PssoWeb.Api.V1.GradingController do
  use PssoWeb, :controller

  def index(conn, _params) do
    gradings = Psso.Grading.list_gradings(conn.assigns.headers, conn.assigns.asi)

    render(conn, "index.json", gradings: gradings)
  end
end
