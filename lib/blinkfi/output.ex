defmodule Blinkfi.Output do
  use GenServer
  alias Nerves.Leds

  # Client
  def start_link() do
    Leds.set [{:green, true}]
    GenServer.start_link(__MODULE__, :ok, name: :blinkfi_output)
  end

  def set() do
    GenServer.cast(:blinkfi_output, {:set, false})
  end

  def clear() do
    GenServer.cast(:blinkfi_output, {:set, true})
  end

  # Server (callbacks)
  def handle_cast({:set, led_state}, _) do
    Leds.set [{:green, led_state}]
    {:noreply, nil}
  end
end
