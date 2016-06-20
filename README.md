# Generating the Intercom snippet

[More info](https://docs.intercom.io/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/the-intercom-javascript-api).

```elixir
# Generate the full Intercom snippet
Intercom.snippet(
  "<your app id>",
  "<your secret key>",
  %{email: "your_data@example.com"}
)
```

Using the Phoenix web framework:

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
      "<your app id>",
      "<your secret>",
      %{email: "bob@foo.com"}
    ))
  end
end
```

# Using the Intercom REST API:

[More info](https://developers.intercom.io/).

```elixir
Intercom.Client.get!(
  "/users",
  [],
  hackney: Intercom.Client.auth("<app id>", "<api key>")
)
```
