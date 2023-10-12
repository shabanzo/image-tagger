# Tagger Test

## Getting Started

### With Docker

1. Make sure docker installed on your machine.
2. Run the application with the following command:

```
docker-compose up web -d
```

### Without Docker

1. Make sure Ruby (2.7.3) installed on your machine.
2. Also make sure the dependencies installed on your machine: postgresql-dev, tzdata, nodejs, yarn
3. Make sure all the dependencies are running, specifically Postgres
4. Run the application with the following command:

```
rails s
```

## Testing

### With Docker

1. Make sure docker installed on your machine.
2. Make sure the container already running.
3. Enter the container by executing following command:

```
docker exec -it web sh
```

4. Run this following command inside the container:

```
bundle exec rspec
```

### Without Docker

1. Make sure all the dependencies above installed on your machine 2. Run the rspec by executing this following command:

```
rspec
```

### Test Category

1. Unit Test: For services and models, testing different contexts within the services.
2. Integration Test: For controllers, testing the end-to-end process from the controller to the model.
