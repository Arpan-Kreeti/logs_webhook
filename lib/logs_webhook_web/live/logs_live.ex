defmodule LogsWebhookWeb.LogsLive do
  use LogsWebhookWeb, :live_view

  alias LogsWebhook.Logs

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, logs: Logs.get_logs(params))}
  end

  # @impl true
  # def handle_event("suggest", %{"q" => query}, socket) do
  #   {:noreply, assign(socket, results: search(query), query: query)}
  # end
end
