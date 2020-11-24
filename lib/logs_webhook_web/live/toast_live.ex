defmodule LogsWebhookWeb.ToastLive do
  use LogsWebhookWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, toast: false)}
  end
end
