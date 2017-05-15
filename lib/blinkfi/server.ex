defmodule Blinkfi.Server do
  def start(port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    listen(socket)
  end

  defp listen(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> recv(conn) end)
    listen(socket)
  end

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, "LED ON\r\n"} ->
        :gen_tcp.send(conn, "Turning on.\r\n")
        Blinkfi.Output.set
        recv(conn)
      {:ok, "LED OFF\r\n"} ->
        :gen_tcp.send(conn, "Turning off.\r\n")
        Blinkfi.Output.clear
        recv(conn)
      {:ok, data} ->
        :gen_tcp.send(conn, data)
        recv(conn)
      {:error, :closed} ->
        :ok
    end
  end
end