# Alma

A client for Web Services provided by the Ex Libris's Alma Library System.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alma', :git => "https://github.com/tulibraries/alma_rb.git"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alma_rb

## Usage

### Configuration

You'll need to configure the Alma gem to ensure you query the appropriate data. To do so in a rails app, create `config/initializers/alma.rb` with :

```ruby
Alma.configure do |config|
  # You have to set te apikey 
  config.apikey     = 'EXAMPLE_EL_DEV_NETWORK_APPLICATION_KEY'
  # Alma gem defaults to querying Ex Libris's North American  Api servers. You can override that here.
  config.region   = "https://api-eu.hosted.exlibrisgroup.com
end
```

Now you can access those configuration attributes with `Alma.configuration.apikey`

### Making Requests

#### Get a list of Users
```ruby
 users = Alma::User.find
 
 users.total count
 > 402
 
 users.list.first.id 
 > 123456789
```
 
#### Get a Single user
```ruby
 user = Alma::User.find({:user_id => 123456789})
 
 user.first_name
 > Chad
 
 user.email
 > chad.nelson@fictional.edu
```
 
#### Get details on a users fines
 
```ruby
 fines = user.fines
 fines.sum
 > "20.0"
 
 fines.total_record_count
 > "2"
 
 fines.list
 > [#<Alma::AlmaRecord:0x000000038b7b50
    ...>,
    #<Alma::AlmaRecord:0x000000038b7b28
     ...>]
 
 fines.list.first.title
 > "Practical Object Oriented Design with Ruby"
 
```

#### Get details on a users loans
 
```ruby
loans = user.loans

loans.total_record_count
> "2"
 
loans.list
> [#<Alma::AlmaRecord:0x000000038c6b79
  ...>,
  #<Alma::AlmaRecord:0x000000038c6b34
   ...>]
 
loans.list.first.title
 > "Javascript: The Good Parts"
 
loans.list.first.due_date
"2016-12-26z
 
```

to renew an item you can pass a loan object to `user.renew_loan`

```ruby

renewal = user.renew_loan(loans.list.first)

renewal.renewed?
> True

renewal.message 
> "Javascript: The Good Parts is now due 02-20-17"


```



#### Get details on a users requests
```ruby
requests = user.requests

requests.total_record_count
> "1"
 
requests.list
> [#<Alma::AlmaRecord:0x000000038c6b79...>]
 
requests.list.first.title
> "Food in history / Reay Tannahill."

requests.list.first.pickup_location
> "Main Library"

requests.list.first.request_status
> "In Process"
 
```
 
 Loans, fines and Requests can also be accessed statically
  
```ruby
Alma::User.get_fines({:user_id => 123456789})
 
Alma::User.get_loans({:user_id => 123456789})

Alma::User.get_requests({:user_id => 123456789})
 
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/alma. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

