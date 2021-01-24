defmodule PssoWeb.Api.V1.GradingView do
  use PssoWeb, :view

  def render("index.json", %{gradings: gradings}) do
    render_many(gradings, __MODULE__, "grading.json")
  end

  def render("grading.json", %{grading: grading}) do
    grading
  end
end
