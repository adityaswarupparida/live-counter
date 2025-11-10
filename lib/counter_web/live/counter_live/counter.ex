defmodule CounterWeb.CounterLive.Counter do
  use CounterWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 0)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <Layouts.app flash={@flash}>
        <section class="shadow-xl border p-4 border-[oklch(70%_0.213_47.604/0.3)]">
          <h1 class="text-2xl">Count: {@count} </h1>
          <div>
            <.button phx-click="increment">+</.button>
            <.button phx-click="decrement">-</.button>
            <.button phx-click="reset">Reset</.button>
          </div>
        </section>
      </Layouts.app>
    """
  end

  def handle_event("increment", _, socket) do
    count = socket.assigns.count + 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end

  def handle_event("decrement", _, socket) do
    count = socket.assigns.count - 1
    socket = assign(socket, :count, count)
    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    socket = assign(socket, :count, 0)
    {:noreply, socket}
  end

end
