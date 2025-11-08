defmodule KvServer.Command do
  require Logger

  def parse(command) do
    case String.split(command) do
      ["CREATE", list] ->
        Logger.info("received request to create a new list : #{list}")
        KvServer.DB.create(String.to_atom(list))

      ["DELETE", list] ->
        Logger.info("received request to delete list : #{list}")
        KvServer.DB.delete_list(String.to_atom(list))

      ["GET", list] ->
        Logger.info("received request to fetch list : #{list}")
        format_data(KvServer.DB.fetch_list(String.to_atom(list)))

      ["PUT", list, item, qty] ->
        Logger.info("received request to add item : #{item} with qty : #{qty}")
        KvServer.DB.add(String.to_atom(list), String.to_atom(item), String.to_integer(qty))

      ["DELETE", list, item] ->
        Logger.info("received request to delete item : #{item}")
        KvServer.DB.remove(String.to_atom(list), String.to_atom(item))

      _ ->
        {:error, :unknown_command}
    end
  end

  def format_data(data) do
    cond do
      is_nil(data) ->
        "no list found\n"

      map_size(data) == 0 ->
        "no items in list\n"

      map_size(data) > 0 ->
        Enum.map(data, fn {k, v} -> "#{k} : #{v}\n" end)
        |> Enum.reduce("", fn x, acc -> acc <> x end)
    end
  end
end
