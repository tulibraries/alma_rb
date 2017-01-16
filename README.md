# Alma

A client for Web Services provided by the Ex Libris's Alma Library System.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alma', :git => https://github.com/tulibraries/alma_rb.git
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
 
 Once you have a user, you can also request that users loans, fines, requests.
 
 ```ruby
 fines = user.fines
 fines.sum
 > 20.0
 
 fines.list.first.title
 > Practical Object Oriented Design with Ruby
 
 user.loans.list
 [\<Item Object 1\>, \<Item Oject 2\>]
 ```
 
 Loans, fines and Requests can also be accessed statically
  
  ```ruby
 fines = Alma::User.get_fines({:user_id => 123456789})
 
 loans = Alma::User.get_loans({:user_id => 123456789})
 
 ```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/alma. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

