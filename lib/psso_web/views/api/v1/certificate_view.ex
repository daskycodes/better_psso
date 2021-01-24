defmodule PssoWeb.Api.V1.CertificateView do
  use PssoWeb, :view

  alias PssoWeb.Router.Helpers, as: Routes
  alias PssoWeb.Endpoint

  def render("index.json", %{certificates: certificates}) do
    render_many(certificates, __MODULE__, "certificate.json")
  end

  def render("certificate.json", %{certificate: certificate}) do
    [_, studien_type, studien_id] =
      String.split(certificate.links.studienbescheinigung, "/", trim: true)

    [_, bafoeg_type, bafoeg_id] =
      String.split(certificate.links.bafoeg_bescheinigung, "/", trim: true)

    %{
      semester: certificate.semester,
      links: %{
        studienbescheinigung:
          Routes.certificate_url(Endpoint, :download, studien_type, studien_id),
        bafoeg_bescheinigung: Routes.certificate_url(Endpoint, :download, bafoeg_type, bafoeg_id)
      }
    }
  end
end
