defmodule PssoWeb.GradingLive do
  use PssoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, maybe_assign_campusid(socket, session)}
  end

  defp maybe_assign_campusid(socket, %{"headers" => headers, "asi" => asi} = _session) do
    assign(socket, headers: headers, asi: asi)
  end

  defp maybe_assign_campusid(socket, _session), do: assign(socket, headers: nil)
end
