# README

This application takes a flight number and tries to find a flight route by it using the Amadeus API(`get "/flight_routes?flight_number=#{flightnumber}"`). All find routes puts in database and fetch from it if they were added in last 24 hour to stay actual.
The application also contain a service that can process a CSV file with flight numbers and create a new `output.csv` with the received data(you can call it by `Handlers::CsvHandler.new.call('filename.csv')`). For example, you can test it with `test.csv` or see `flight_number.csv` with results.
For use application, you need to obtain test API keys from [Amadeus](https://developers.amadeus.com). Register [here](https://developers.amadeus.com/register) and [set up your first application](https://developers.amadeus.com/my-apps) to get keys. Place them in the `.env` file in the root:
```
AMADEUS_CLIENT_ID=your_API_key
AMADEUS_CLIENT_SECRET=your_API_secret
```
Application Dockerized, so you should run `docker/setup` first to setup application. Then use `docker compose up` for launch it (or `docker/start` for launch in background and `docker/stop` for stop)
For see tests result use `docker/rspec`. All rails commands launch trough `docker/rails` (like `docker/rails console` or `docker/rails db:migrate`), and bundle trough `docker/bundle`. Or you can just run `docker/update` if you add some gems or changes in database schema. Also use `docker/lint` for rubocop check and `docker/run` for any other bash command.

Used: Rails 7.1.1, Ruby 3.1.2, Docker 24.0.6

## Update 0.02:

- authorization token now stored with Rails cach instead of database;
- most of requests from specs now stored in special 'cassettes' with 'vcr' gem to avoid unnecessary request to API;
- added unit tests for services;
- added flight_numbers.csv file as an example of results;
- fixed a lot of various bags.