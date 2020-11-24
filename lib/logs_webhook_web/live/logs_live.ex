defmodule LogsWebhookWeb.LogsLive do
  use LogsWebhookWeb, :live_view

  alias LogsWebhook.Logs
  alias LogsWebhookWeb.ToastLive
  @live_logs_topic "live_logs_topic"
  @toast_duration 1500

  @impl true
  def mount(params, _session, socket) do
    LogsWebhookWeb.Endpoint.subscribe(@live_logs_topic)

    {:ok, assign(socket, logs: Logs.get_logs(params), params: params, timer_ref: nil)}
  end

  @impl true
  def handle_event("search", search_params, %{assigns: %{params: page_params}} = socket) do
    params = Map.merge(page_params, search_params)
    {:noreply, assign(socket, logs: Logs.get_logs(params), params: params)}
  end

  @impl true
  def handle_info(
        %{event: "new_log"},
        %{assigns: %{params: params, timer_ref: old_timer_ref}} = socket
      ) do
    if old_timer_ref, do: Process.cancel_timer(old_timer_ref)
    timer_ref = Process.send_after(self(), :remove_toast, @toast_duration)

    send_update(ToastLive, id: "toast", toast: true)

    {:noreply, assign(socket, logs: Logs.get_logs(params), timer_ref: timer_ref)}
  end

  @impl true
  def handle_info(:remove_toast, socket) do
    send_update(ToastLive, id: "toast", toast: false)
    {:noreply, assign(socket, timer_ref: nil)}
  end
end
