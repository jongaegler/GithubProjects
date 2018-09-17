# README

Set ACCESS_TOKEN with
`export ACCESS_TOKEN=YOUR_TOKEN_HERE` which I will email to you.

then run bin/setup

Start server with `rails s` and navigate to `localhost:3000`

The front end is a very basic rails app that allows inspection of each batch increment count.

Future considerations:

This project has a breaking point for if any star has more than 1000 search results.
I tested hypothetically going back 3 days instead of just one with the required constraints and it was still much less than 1000. Given that this is a test, this seems like a sufficient solution.

