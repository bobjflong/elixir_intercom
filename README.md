# Usage

```elixir
# Generate the full Intercom snippet
IntercomJavascript.snippet(
  "<your app id>",
  "<your secret key>",
  %{email: "your_data@example.com"}
)
```

Using the Phoenix web framework:

```elixir
defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller
  require IntercomJavascript

  plug :intercom

  def index(conn, _params) do
    # Intercom injectable via <%= raw @intercom %>
    render conn, "index.html"
  end

  defp intercom(conn, _params) do
    assign(conn, :intercom, IntercomJavascript.snippet(
      "<your app id>",
      "<your secret>",
      %{email: "bob@foo.com"}
    ))
  end
end
```
