# README

This project is a Ruby on Rails API for encoding and decoding URLs into short hashes.

## It provides 2 main endpoints:
- POST /encode → creates a short URL hash
- POST /decode → returns the original URL from the hash

Includes URL validation, RSpec tests, and PostgreSQL support.

## Public URL
Path: https://complete-charlene-dina-c074c315.koyeb.app/
Port: 8000

## Encoding / Decoding algorithm
- I needed to use the db to be able to decode old urls when restarting the server per requirement.
- I wanted the decoding algorithm to avoid relying on reversible (two-way) hashing and instead use a randomized hashing approach to minimize the risk of collisions.
- I wanted the hash key to be index-friendly to speed up lookups in the table. Therefore, I applied two hashing steps: first SHA1, followed by Base62 encoding, which is optimized for indexing.
- Using indecies will have a certain limit, so for future enhancements we can rely on elastic-search, but indecies is enough for now.
- I used transaction, and a lock to prevent race conditions from occur when trying to encode the same urls from two different transactions
- I validated the url on the level of controller and db models

## API Request
- /encode endpoint
```
curl --location 'https://complete-charlene-dina-c074c315.koyeb.app/encode' \
--header 'Content-Type: application/json' \
--data '{"url": "https://guides.rubyonrails.org/active_record_validations.html#format"}'
```

- /decode endpoint
```
curl --location 'https://complete-charlene-dina-c074c315.koyeb.app/decode' \
--header 'Content-Type: application/json' \
--data '{"url": "https://complete-charlene-dina-c074c315.koyeb.app/jyllkrtWY3j"}'
```
## How to run the assesment
You can check Assesment_RUN.md file

