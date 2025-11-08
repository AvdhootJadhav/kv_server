defmodule KvServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "4040")

    children = [
      {Task.Supervisor, name: KvServer.TaskSupervisor},
      {KvServer.DB, fn -> KvServer.DB.start_link(%{}) end},
      Supervisor.child_spec({Task, fn -> KvServer.start(port) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: KvServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
