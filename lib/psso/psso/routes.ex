defmodule Psso.Psso.Routes do
  def grading_params(asi) do
    params = %{
      state: "notenspiegelStudent",
      next: "list.vm",
      nextdir: "qispos/notenspiegel/student",
      createInfos: "Y",
      struct: "auswahlBaum",
      nodeID: "auswahlBaum|abschluss:abschl=BA|studiengang:stg=COD,vert=CON,poversion=1",
      expand: 0,
      asi: asi
    }

    [params: params]
  end

  def set_asi_params do
    params = %{
      state: "change",
      type: "1",
      moduleParameter: "studyPOSMenu",
      nextdir: "change",
      next: "menu.vm",
      subdir: "applications",
      xml: "menu"
    }

    [params: params]
  end

  def certificates_params() do
    params = %{
      state: "verpublish",
      publishContainer: "studbeschSemester",
      menuid: "studtbeschAnySemester",
      breadcrumb: "qissos_reports_studentReport_anyTerm",
      breadCrumbSource: "menu",
      noDBAction: "y",
      init: "y"
    }

    [params: params]
  end

  def certificates_download_params(type, id) do
    params = %{
      state: "verpublish",
      status: "transform",
      vmfile: "no",
      moduleCall: "Report",
      publishSubDir: "qissosreports",
      publishConfFile: type,
      publishid: id
    }

    [params: params]
  end

  def log_in_url, do: "https://psso.th-koeln.de/qisserver/rds?state=user&type=7"
  def log_out_url, do: "https://psso.th-koeln.de/qisserver/rds?state=user&type=4"
  def base_url, do: "https://psso.th-koeln.de/qisserver/rds"
end
