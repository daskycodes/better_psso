defmodule PssoWeb.CertificateDownloadController do
  use PssoWeb, :controller

  import Psso.Routes

  def download_certificate(conn, %{"type" => type, "id" => id} = _params) do
    %{"headers" => headers} = Plug.Conn.get_session(conn)

    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get(base_url(), headers, certificates_download_params(type, id))

    send_download(conn, {:binary, body}, filename: "#{type}-#{id}.pdf")
  end
end
