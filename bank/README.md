# Bank

- Start your service with `docker-compose up`
- Run project test suite with `docker-compose run bank mix test`
- Start IEx session in running service
      # Find a container id using docker ps
      docker exec -it <container-id> bash

      # In container
      iex --sname debug --remsh app@$(hostname)

Alternatively, you can still run the project directly, without docker:

- Install dependencies with `mix deps.get`- Start your service with `iex -S mix`

## Learn more

- Raxx documentation: https://hexdocs.pm/raxx
- Slack channel: https://elixir-lang.slack.com/messages/C56H3TBH8/
