# How to run the assesment

## Clone the repo
```
git clone https://github.com/dinaalaaahmed/oivan_assesment.git
cd oivan_assesment

```

## Set RAILS_ENV (example: development, test, production)
```
export RAILS_ENV=development
```

## Build docker container
```
docker-compose build
```

## Setup database inside docker
```
docker-compose run -e RAILS_ENV=$RAILS_ENV web rails db:create db:migrate
```

## Start the App on localhost:3000
```
docker-compose up
```

## Run tests
```
docker-compose exec web bash -c "RAILS_ENV=test bundle exec rspec"
```

## Stop docker container
```
docker-compose down
```
