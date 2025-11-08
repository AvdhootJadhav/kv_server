defmodule KvServer do
  require Logger

  def start(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true, packet: :line])

    Logger.info("KvServer started...")
    Logger.info("accepting connections on port : #{port}")
    accept(socket)
  end

  defp accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(KvServer.TaskSupervisor, fn -> serve_req(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    accept(socket)
  end

  defp serve_req(socket) do
    socket
    |> read_data()
    |> KvServer.Command.parse()
    |> send_data(socket)

    serve_req(socket)
  end

  defp read_data(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp send_data(data, socket) do
    case data do
      :ok ->
        :gen_tcp.send(socket, "ok\n")

      {:error, reason} ->
        :gen_tcp.send(socket, "#{Atom.to_string(reason)}\n")

      _ = msg ->
        :gen_tcp.send(socket, msg)
    end
  end
end
