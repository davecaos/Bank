defmodule Bank.API.Router do
  use Raxx.Router
  alias Bank.API.Actions

  def stack(config) do
    Raxx.Stack.new(
      [
        # Add global middleware here.
      ],
      {__MODULE__, config}
    )
  end

  # Call GreetUser and in WWW dir AND call into lib
  section [{Raxx.Logger, Raxx.Logger.setup(level: :info)}], [
    {%{path: ["lallas"]}, Actions.WelcomeMessage},
    {%{path: ["users"]}, Actions.CreateUsers},
  ]

  section [{Raxx.Logger, Raxx.Logger.setup(level: :debug)}], [
    {_, Actions.NotFound}
  ]
end
