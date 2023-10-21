# README

This application takes a flight number and tries to find a flight route using it using the Amadeus API(`get "/flight_routes?flight_number=#{flightnumber}"`). All find routes puts in database and fetch fron it if they was added in last 24 hour to stay actual.
The application also implements a service that can process a CSV file with flight numbers and create a new `output.csv` with the received data(you can call it by `Handlers::CsvHandler.new.call('filename.csv')`).  For example you can test it with `test.csv`.
For the application to work, you need to obtain API keys from Amadeus (https://developers.amadeus.com) and place them in the `.env` file in the root.
```
AMADEUS_CLIENT_ID=your_API_key
AMADEUS_CLIENT_SECRET=your_API_secret
```
Or you can checkout to previous commit and try application in test mode (with hardcoded respons)

Application Dockerized, so you shuld run `docker/setup` first to setup application. Than use `docker compose up` for launch it (or `docker/start` for launch in background and `docker/stop` for stop)
For see tests result use `docker/rspec`. For all rails commands use `docker/rails` (like `docker/rails console` or `docker/rails db:migrate`), and `docker/bundle` for bundle commands. And you can just run `docker/update` if you add some gems or changes in database schema. Also use `docker/lint` for rubocop check and `docker/run` for any other bash command.

Used: Rails 7.1.1, Ruby 3.1.2, Docker 24.0.6