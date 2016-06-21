[![Build Status](https://travis-ci.org/bobjflong/elixir_intercom.svg?branch=master)](https://travis-ci.org/bobjflong/elixir_intercom)

# Intercom snippet

Intercom can be installed in your web app to help you chat to logged-in and logged-out users.

[Full configuration options can be found here](https://docs.intercom.io/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/the-intercom-javascript-api).

```elixir
require Intercom

# Generate the full Intercom snippet
Intercom.snippet(
  %{email: "your_data@example.com"}, # Key value pairs identifying your user.
  app_id: "<your app id>", # Your app's identifier.
  secret: "<your secret key>" # Your app's secret key. This enables secure mode https://docs.intercom.io/configure-intercom-for-your-product-or-site/staying-secure/enable-secure-mode-on-your-web-product
)
```

For example, this shows how to generate the web snippet in a [Phoenix](http://www.phoenixframework.org/) web app:

```elixir
defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller
  require Intercom

  plug :intercom

  def index(conn, _params) do
    # Intercom injectable via <%= raw @intercom %>
    render conn, "index.html"
  end

  defp intercom(conn, _params) do
    assign(conn, :intercom, Intercom.snippet(
      %{email: "bob@foo.com"},
      app_id: "<your app id>",
      secret: "<your secret>"
    ))
  end
end
```

# Intercom REST API:


The Intercom [REST API](https://developers.intercom.io/) provides full access to Intercom resources. This library provides a thin wrapper over [httpoison](https://github.com/edgurgel/httpoison):

```elixir
require Intercom.Client

Intercom.Client.start

Intercom.Client.get!(
  "/users",
  [],
  hackney: Intercom.Client.auth("<app id>", "<api key>")
)
```
