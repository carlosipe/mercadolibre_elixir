defmodule Mercadolibre.Authentication do
  use GenServer

  # Public API
  def start_link(state = %{client_id: _, client_secret: _}, options \\ []) do
    GenServer.start_link(__MODULE__, state, options)
  end

  def get_token(client) do
    GenServer.call(client, :get_token)
  end

  def invalidate_token(client, old_token) do
    GenServer.cast(client, {:invalidate_token, old_token})
  end

  # GenServer API
  def handle_call(:get_token, _from, state = %{token: token}) do
    {:reply, token, state}
  end

  def handle_call(:get_token, _from, state) do
    token = Mercadolibre.request_access_token(Map.take(state, [:client_id, :client_secret]))
    {:reply, token, Map.put(state, :token, token)}
  end

  def handle_cast({:invalidate_token, bad_token}, state = %{token: token}) when token == bad_token do
    {:noreply, Map.delete(state, :token)}
  end

  def handle_cast({:invalidate_token, _}, state) do
    {:noreply, state}
  end
end
