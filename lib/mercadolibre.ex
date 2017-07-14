defmodule Mercadolibre do
  alias Mercadolibre.Authentication
  @base_url "https://api.mercadolibre.com"
  
  def authenticated_request(client, verb, url, data) do
    token = Authentication.get_token(client)
    url = url <> "?access_token=#{token}" 
    {status_code, response} = request(verb, url, data)
    if status_code == 401, do: Authentication.invalidate_token(client, token)

    {status_code, response}
  end

  def request(verb, url), do: request(verb, url,[])
  def request(verb, url, data) do
    url = URI.merge(@base_url, url)
    {:ok, response} = HTTPoison.request verb, url,data, [{"Content-Type", "application/json"}]
    {response.status_code, JSX.decode!(response.body)}
  end

  def request_access_token(%{client_id: client_id, client_secret: client_secret}) do
    payload = JSX.encode!( %{client_id: client_id, client_secret: client_secret, grant_type: "client_credentials"}  )
    {_status_code, response} = request(:post, "oauth/token", payload)
    %{"access_token" => access_token} = response

    access_token
  end
end
