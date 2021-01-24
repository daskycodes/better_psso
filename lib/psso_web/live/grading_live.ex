defmodule PssoWeb.GradingLive do
  use PssoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    send(self(), {:load_data, session})
    {:ok, assign(socket, data: :loading)}
  end

  @impl true
  def handle_info({:load_data, %{"headers" => headers, "asi" => asi} = _session}, socket) do
    data = raw(Psso.Psso.grading_table(headers, asi))
    {:noreply, assign(socket, data: data)}
  end

  def handle_info({:load_data, _session}, socket), do: {:noreply, socket}
end
