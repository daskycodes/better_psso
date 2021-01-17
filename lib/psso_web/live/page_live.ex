defmodule PssoWeb.PageLive do
  use PssoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    send(self(), {:load_data, session})
    {:ok, maybe_assign_campusid(socket, session)}
  end

  @impl true
  def handle_info({:load_data, %{"headers" => headers, "asi" => asi} = _session}, socket) do
    data = raw(Psso.Psso.student_table(headers, asi))
    {:noreply, assign(socket, data: data)}
  end

  def handle_info({:load_data, _session}, socket), do: {:noreply, socket}

  defp maybe_assign_campusid(socket, %{"headers" => _headers, "asi" => _asi} = _session) do
    data = raw("<div class='skeleton'></div>")
    assign(socket, campusid: true, data: data)
  end

  defp maybe_assign_campusid(socket, _session),
    do: assign(socket, campusid: nil)
end
