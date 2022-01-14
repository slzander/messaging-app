# Messenger Api

## Overview

This is a basic Rails API to enable messaging between users. 

## Dependencies/Versions

* Ruby 2.6.1
* Rails 6.0.4
* SQLite3 1.4
* Gems added to this project:
  * [RSpec](https://github.com/rspec/rspec-rails)
  * [Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers)
  * [Faker](https://github.com/faker-ruby/faker)
  * [Pry](https://github.com/pry/pry)

## Setup

  1. Clone this repo.
  
  1. Install gems by running `bundle install`

  1. Run `rails db:migrate` to create and migrate the database.

  1. Run `rails db:seed` to seed the database with users. 

  1. Run `rails s` to start the Rails server.

  1. To run the test suite, run `rspec`


## Using the API

  1. Use Postman or curl commands for GET and POST requests.

  1. `/users` will give you all users. You can see individual users at `/users/{:id}`

  1. `/users/{:id}/messages` will give you all of the messages received by a given user. These will be limited to 100 records within the last 30 days, and will be sorted newest to oldest.

  1. `/users/{:id}/messages?sender_id={:id}`, will filter the user's messages to only include those from the specified sender. Sort and limits still apply.

  1. You can create a new user at `/users`. Include the following in your POST request:

  ```
    {
      "name": "Stacey",
      "email": "stacey@zander.com"
    }

  ```

  1. You can create a new message at `/messages`. Include the following in your POST request (sender and recipient ids refer to their user ids):

  ```
    {
      "body": "My message to you",
      "sender_id": "1",
      "recipient_id": "2"
    }

  ```


## Future directions

With more time, there are several things I'd like to implement:

* I didn't have time to write any controller tests, which is what my next step would be.
* Add better error handling in controllers, more specific error responses.
* Would be fun to implement more flexible limitations on the message requests (number of messages and time frame).
* Authentication/Authorization for users are obvious next steps as well.


