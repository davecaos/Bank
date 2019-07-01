defmodule Bank.API do

  def child_spec([server_options]) do
    {:ok, port} = Keyword.fetch(server_options, :port)
    %{
      id: {__MODULE__, port},
      start: {__MODULE__, :start_link, [server_options]},
      type: :supervisor
    }
  end

  def init() do
    %{}
  end

  def start_link(server_options) do
    start_link(init(), server_options)
  end

  def start_link(config, server_options) do
    stack = Bank.API.Router.stack(config)
    Ace.HTTP.Service.start_link(stack, server_options)
  end

  # Utilities
  def set_json_payload(response, data) do
    response
    |> Raxx.set_header("content-type", "application/json")
    |> Raxx.set_body(Jason.encode!(data))
  end
end
