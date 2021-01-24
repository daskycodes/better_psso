defmodule PssoWeb.Api.V1.CertificateController do
  use PssoWeb, :controller

  import Psso.Routes

  def index(conn, _params) do
    certificates = Psso.Certificates.list_certificates(conn.assigns.headers, conn.assigns.asi)

    render(conn, "index.json", certificates: certificates)
  end

  import Psso.Routes

  def download(conn, %{"type" => type, "id" => id} = _params) do
    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get(base_url(), conn.assigns.headers, certificates_download_params(type, id))

    send_download(conn, {:binary, body}, filename: "#{type}-#{id}.pdf")
  end
end
