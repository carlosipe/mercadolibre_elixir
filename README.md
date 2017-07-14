# Mercadolibre

An elixir wrapper for MercadoLibre.com API

## Installation

  1. Add `mercadolibre` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mercadolibre, "~> 0.1.0"}]
end
```

## Usage

```elixir
{:ok, auth} = Mercadolibre.Authentication.start_link(%{client_id: "x", client_secret: "y"}) 
Mercadolibre.authenticated_request(auth, :get, "items/MLA123")
```

It returns a tuple like `{status_code, decoded_response}`

If the endpoint you are calling doesn't need authentication, you can use this directly:

```elixir
Mercadolibre.request(:get, "/items/MLA123", [])
```
 
## Supervision

   
Probably you'll want a supervised Authentication process.

```elixir
# ...
children = [
  worker(Authentication, [%{client_id: "x", client_secret: "y"}, name: :account1])
]
supervise(children, strategy: one_for_one)
```

and then:
```elixir
Mercadolibre.authenticated_request(:account1, :post, "items", %{title: "Title", price: 10})
```

## MercadoLibre.com API

This library doesn't pretend to wrap Mercadolibre's API into nice named methods.
Why? Because I don't want to have to update the Hex everytime the API changes.
We are just abstracting the part of dealing with request, json or authentication.
To know which url to call and which data, just read the documentation. But it's as
easy as:
```elixir
{:ok, account} = Mercadolibre.Authentication.start_link(credentials)

# Items

Mercadolibre.request              (         :get,  "items/MLA1234" )
Mercadolibre.authenticated_request(account, :post, "items", item_data)
Mercadolibre.authenticated_request(account, :put,  "items/MLA123", data)
Mercadolibre.authenticated_request(account, :delete, "items/MLA123")

# Users

Mercadolibre.authenticated_request(account, :get, "users/me")
Mercadolibre.authenticated_request(account, :get, "users/1/addresses")
...
```
