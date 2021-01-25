defmodule PssoWeb.GradingLive do
  use PssoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    send(self(), {:load_data, session})
    {:ok, assign(socket, data: :loading, stats: %{})}
  end

  @impl true
  def handle_info({:load_data, %{"headers" => headers, "asi" => asi} = _session}, socket) do
    data = raw(Psso.Grading.get_grading_table(headers, asi))
    stats = Psso.Grading.get_grading_stats(headers, asi)
    {:noreply, assign(socket, data: data, stats: stats)}
  end

  def handle_info({:load_data, _session}, socket), do: {:noreply, socket}
end
