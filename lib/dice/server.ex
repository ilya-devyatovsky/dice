defmodule Dice.Server do
  use GenServer.Behaviour
  use Dice.Database

  #######
  # API #
  #######

  def start_link do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def stop do
    :gen_server.cast(__MODULE__, :stop)
  end

  def put(key, value) do
    :gen_server.call(__MODULE__, {:put, key, value})
  end

  def get(key) do
    :gen_server.call(__MODULE__, {:get, key})
  end

  def remove(key) do
    :gen_server.call(__MODULE__, {:remove, key})
  end

  #############
  # Callbacks #
  #############

  def init(_) do
    # NOTE: OMG! Does tihs automatically connect?
    # Amnesia.Schema.create([:'master@benjamintan', :'slave1@benjamintan', :'slave2@benjamintan'])
    # Amnesia.start
    # # TODO: Remove this later. Use the become_master/become_slave
    # Database.create(disk: [:'master@benjamintan', :'slave1@benjamintan', :'slave2@benjamintan'])

    {:ok, []}
  end

  def terminate(_reason, _state) do
    Amnesia.stop
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_call({:put, key, value}, _from, state) do
    {:reply, Database.DiceCache.put(key, value), state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Database.DiceCache.get(key), state}
  end

  def handle_call({:remove, key}, _from, state) do
    {:reply,  Database.DiceCache.remove(key), state }
  end

end
