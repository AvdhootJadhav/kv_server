defmodule KvServer.DB do
  require Logger
  use GenServer

  def start_link(init_arg) do
    Logger.info("KvServer DB started...")
    GenServer.start_link(__MODULE__, init_arg, name: :db)
  end

  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast(request, state) do
    case request do
      {:delete, list} ->
        {:noreply, Map.delete(state, list)}

      {:put, list, item, qty} ->
        {:noreply, Map.put(state, list, Map.get(state, list) |> Map.put(item, qty))}

      {:delete, list, item} ->
        {:noreply, Map.put(state, list, Map.get(state, list) |> Map.delete(item))}

      {:create, list} ->
        case Map.get(state, list) do
          nil ->
            {:noreply, Map.put(state, list, %{})}

          _ ->
            {:noreply, state}
        end
    end
  end

  @impl true
  def handle_call(request, _from, state) do
    case request do
      {:get, list} ->
        {:reply, Map.get(state, list), state}
    end
  end

  def fetch_list(list) do
    GenServer.call(:db, {:get, list})
  end

  def create(list) do
    GenServer.cast(:db, {:create, list})
  end

  def delete_list(list) do
    GenServer.cast(:db, {:delete, list})
  end

  def add(list, item, qty) do
    GenServer.cast(:db, {:put, list, item, qty})
  end

  def remove(list, item) do
    GenServer.cast(:db, {:delete, list, item})
  end

  def stop do
    GenServer.stop(:db)
  end
end
