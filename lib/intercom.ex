defmodule Intercom do
  alias ESTree.Tools.Builder
  alias ESTree.Tools.Generator

  def to_javascript_object(dict) when is_map(dict) do
    props = Enum.map(dict, fn {k, v} ->
      k |> Builder.identifier |> Builder.property(Builder.literal(v))
    end)
    Builder.object_expression(props)
  end

  def boot(opts) when is_map(opts) do
    Builder.call_expression(
      Builder.identifier(:Intercom),
      [
        Builder.literal(:boot),
        to_javascript_object(opts)
      ]
    )
  end

  def inject_user_hash(secret, opts) when is_map(opts) do
    key = cond do
      Map.has_key?(opts, :user_id) -> :user_id
      Map.has_key?(opts, :email) -> :email
      true -> raise "email or user_id required"
    end

    case secret do
      nil -> opts
      _ -> Map.merge(opts, %{:user_hash => :sha256
        |> :crypto.hmac(secret, Map.fetch!(opts, key))
        |> Base.encode16
        |> String.downcase
      })
    end
  end

  def snippet(app_id, secret \\ nil, opts) when is_map(opts) do
    base = "<script>(function(){var w=window;var ic=w.Intercom;if(typeof ic===\"function\"){ic('reattach_activator');ic('update',intercomSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Intercom=i;function l(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/#{app_id}';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}};})();"
    ast = secret |> inject_user_hash(Map.merge(opts, %{:app_id => app_id})) |> boot
    base <> Generator.generate(ast) <> ";</script>"
  end
end
