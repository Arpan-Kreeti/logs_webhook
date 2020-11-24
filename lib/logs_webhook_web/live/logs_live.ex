defmodule LogsWebhookWeb.LogsLive do
  use LogsWebhookWeb, :live_view

  alias LogsWebhook.Logs
  @live_logs_topic "live_logs_topic"

  @impl true
  def mount(params, _session, socket) do
    LogsWebhookWeb.Endpoint.subscribe(@live_logs_topic)

    {:ok, assign(socket, logs: Logs.get_logs(params), page: params)}
  end

  @impl true
  def handle_info(%{event: "new_log"}, %{assigns: %{page: params}} = socket) do
    {:noreply, assign(socket, logs: Logs.get_logs(params))}
  end

  @impl true
  def handle_event("search", search_params, %{assigns: %{page: page_params}} = socket) do
    params = Map.merge(search_params, page_params)
    {:noreply, assign(socket, logs: Logs.get_logs(params))}
  end
end
