defmodule CounterWeb.CounterLive.Counter do
  use CounterWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    socket =
      socket
      |> assign(:count, 0)
      |> assign(:date, NaiveDateTime.local_now())
      |> assign(:timer_running, false)
      |> assign(:elapsed, 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <Layouts.app flash={@flash}>
        <section class="shadow-xl border p-4 flex items-center justify-between">
          <div class="border p-4 border-[oklch(70%_0.213_47.604/0.3)]">
            <h1 class="text-2xl mb-2">Count: {@count} </h1>
            <.button phx-click="increment">+</.button>
            <.button phx-click="decrement">-</.button>
            <.button phx-click="reset">Reset</.button>
          </div>
          <div class="border p-4 border-[oklch(70%_0.213_47.604/0.3)]">
            <h1 class="text-3xl mb-2">{Calendar.strftime(format_timer(@elapsed), "%H:%M:%S")} </h1>
            <.button phx-click="start">Start</.button>
            <.button phx-click="stop">Stop</.button>
            <.button phx-click="reset_clock">Reset</.button>
          </div>
          <div class="border p-4 border-[oklch(70%_0.213_47.604/0.3)]">
            <h1 class="text-3xl mb-2">{Calendar.strftime(@date, "%H:%M:%S")} </h1>
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

  def handle_event("start", _, socket) do
    {:noreply, assign(socket, :timer_running, true)}
  end

  def handle_event("stop", _, socket) do
    {:noreply, assign(socket, :timer_running, false)}
  end

  def handle_event("reset_clock", _, socket) do
    socket = assign(socket, :elapsed, 0)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)

    socket =
      socket
      |> assign(:date, NaiveDateTime.local_now())
      |> tick_timer()

    {:noreply, socket}
  end

  defp tick_timer(%{assigns: %{timer_running: true, elapsed: sec}} = socket) do
    assign(socket, :elapsed, sec + 1)
  end

  defp tick_timer(socket), do: socket

  defp format_timer(amount_to_add) do
    Time.add(~T[00:00:00], amount_to_add, :second)
  end

end
