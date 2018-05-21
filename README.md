# Alma

A client for Web Services provided by the Ex Libris's Alma Library System.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alma'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alma

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

#### Get a Single user
```ruby
 user = Alma::User.find(123456789)

 user.first_name
 > Chad

 user.email
 > chad.nelson@fictional.edu

 user.keys
 >{first_name: "Chad",
 ...}
```

#### Get details on a users fines

```ruby
 fines = user.fines
 fines.sum
 > "20.0"

 fines.total_record_count
 > "2"

 fines
 > [#<Alma::AlmaRecord:0x000000038b7b50
    ...>,
    #<Alma::AlmaRecord:0x000000038b7b28
     ...>]

 fines.first.title
 > "Practical Object Oriented Design with Ruby"

```

Each fine object reflects the available fields in the returned JSON,[as documented on the Ex Libris Api docs](https://developers.exlibrisgroup.com/alma/apis/xsd/rest_fees.xsd?tags=GET)

#### Get details on a users loans

```ruby
loans = user.loans

loans.total_record_count
> "2"

loans
> [#<Alma::Loan:0x000000038c6b79
  ...>,
  #<Alma::Loan:0x000000038c6b34
   ...>]

loans.first.title
 > "Javascript: The Good Parts"

loans.first.due_date
"2016-12-26z

```
Each loan object reflects the available fields in the returned XML,[as documented on the Ex Libris Api docs](https://developers.exlibrisgroup.com/alma/apis/xsd/rest_item_loans.xsd?tags=GET)


#### Get details on a users requests - WIP
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
Each request object reflects the available fields in the returned XML,[as documented on the Ex Libris Api docs](https://developers.exlibrisgroup.com/alma/apis/xsd/rest_user_requests.xsd?tags=GET)

 Loans, fines and Requests can also be accessed statically

```ruby
Alma::User.get_fines({:user_id => 123456789})

Alma::User.get_loans({:user_id => 123456789})

Alma::User.get_requests({:user_id => 123456789})

```

### Bib Records
Wrappings for some of the API endpoints described by the [Bibliographic Records and Inventory
](https://developers.exlibrisgroup.com/alma/apis/bibs) section of the Ex Libris Developers Network

### All the items for a Bib Records
Corresponds to the [Retrieve Items list](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvNcHQT0/ozqu3DGTurs/XxIP4LrexQUdc=/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) api endpoint

To get the list of items for all holdings of a bib record.
`items = Alma::BibItems.find("EXAMPLE_MMS_ID")`

You can also pass a holding ID as an option, if you only want that holdings items.
`items = Alma::BibItems.find("EXAMPLE_MMS_ID", holding_id: EXAMPLE_HOLDING_ID)`


The response is a BibItemSet which can be iterated over to access items:

```ruby
items.each { ... }

items.total_record_count
> 4
```

You can remove items that are missing or lost from the result set
` avail_items = items.filter_missing_and_lost
`

Items can be grouped by the library they are held at, which returns a hash with library codes as the keys and an array of items as the values.

```ruby
items.grouped_by_library
{ "MAIN" =>
  [#<Alma::BibItem:0x000000038c6b79...>],
  "NOT_MAIN" =>
  [#<Alma::BibItem:0x000000038c6b88...>, #<Alma::BibItem:0x000000038c6b94...>,],
}
```

The data for each item can be accessed via hash representation of the [item structure](https://developers.exlibrisgroup.com/alma/apis/xsd/rest_item.xsd), e.g.:

```ruby
item = items.first

item["holding_data"]["call_number"]
"T385 .F79 2008"

item["item_data"]["location"]["value"]
"STACKS"

```

There are also numerous convenience methods

```ruby
# Boolean checks
item.in_temp_location?
item.in_place? # Basically, On Shelf or Not
item.non_circulating?
item.missing_or_lost?
item.has_temp_call_number?
item.has_alt_call_number?
item.has_process_type?


# Opinionated Accessors - return the value, or an empty string

# Returns temp library/location if appropriate, else normal library/location
item.library
item.library_name
item.location
item.location_name

# which use these methods under the hood
item.holding_library
item.holding_location

item.temp_library
item.temp_location


# Looks for Temp call number, then alternate call number, then normal call number
item.call_number

# and which use
item.temp_call_number
item.alt_call_number



# standard accessors
item.process_type
item.base_status
item.circulation_policy
item.description
item.public_note

```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tulibraries/alma_rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
