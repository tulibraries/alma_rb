$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "alma"
require 'pry'
require 'webmock/rspec'
require 'simplecov'
SimpleCov.start

SPEC_ROOT = File.dirname __FILE__

RSpec.configure do |config|
  config.before(:each) do


    # User details
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/single_user.json').read)

    #fees / fines
    stub_request(:get, /.*\/users\/.*\/fees.*/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/fines.json'))

    # user requests
    stub_request(:get, /.*\/users\/.*\/requests.*/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/requests.json'))

    stub_request(:get, /.*\/users\/.*\/requests.*/).
        with(query: hash_including({offset: "100" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/requests-pg2.json'))

    stub_request(:get, /.*\/users\/.*\/requests.*/).
        with(query: hash_including({offset: "200" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/requests-pg3.json'))

    # successful user authentication
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        with(query: hash_including({password: 'right_password'})).
        to_return(:status => 204)

    # failed user authentication
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        with(query: hash_including({password: 'wrong_password'})).
        to_return(:status => 400)

    # user loans
    stub_request(:get, /.*\/users\/.*\/loans.*/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/loans-pg1.json'))

    stub_request(:get, /.*\/users\/.*\/loans.*/).
        with(query: hash_including({offset: "100" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/loans-pg2.json'))

    stub_request(:get, /.*\/users\/.*\/loans.*/).
          with(query: hash_including({offset: "200" })).
          to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                   :body => File.open(SPEC_ROOT + '/fixtures/loans-pg3.json'))

    # loan renewal
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/loans\/.*/).
        with(query: hash_including({op: 'renew'})).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/renewal_success.json'))

    # Request bibs info

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/multiple_bibs.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/foo\/holdings\/.*\/items/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/bib_items.json'))

    # Bib items sets

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991026207509703811\/holdings\/.*\/items.*/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/bib_items-pg1.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991026207509703811\/holdings\/.*\/items.*/).
        with(query: hash_including({offset: "100" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/bib_items-pg2.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991026207509703811\/holdings\/.*\/items.*/).
        with(query: hash_including({offset: "200" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/bib_items-pg3.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991026207509703811\/holdings\/.*\/items.*/).
        with(query: hash_including({offset: "300" })).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/bib_items-pg4.json'))

    # Request options

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/request-options/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/request_options.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/NOHOLD\/request-options/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/request_options_no_hold.json'))

    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/foo\/requests/).
        to_return(:status => 200)

    stub_request(:get,/.*\/.*error/).
        to_return(:status => 400,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/error.json'))

    # Item Level Request options

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items\/.*\/request-options/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/request_options.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/ITEMNOHOLD\/holdings\/123\/items\/456\/request-options/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/request_options_no_hold.json'))

    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items\/.*\/requests/).
        to_return(:status => 200)

    # Item from barcode
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/items.*/).
      to_return(:status => 302,
                headers: { "Location" => "/almaws/v1/bibs/99117110763506421/holdings/22195173890006421/items/23195173880006421" }
               )
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/99117110763506421\/holdings\/22195173890006421\/items\/23195173880006421.*/).
      to_return(:status => 200,
                 :headers => { "Content-Type" => "application/json" },
                 :body => File.open(SPEC_ROOT + '/fixtures/item_from_barcode.json'))

    # Holding
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/991227850000541\/holdings\/2282456310006421.*/).
      to_return(:status => 200,
                 :headers => { "Content-Type" => "application/json" },
                 :body => File.open(SPEC_ROOT + '/fixtures/single_holding.json'))

    # libraries
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/conf\/libraries$/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/libraries.json'))

    # single library
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/conf\/libraries\/main/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/library.json'))

    # locations
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/conf\/libraries\/main\/locations$/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/locations.json'))

    # single location
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/conf\/libraries\/main\/locations\/offsite/).
        to_return(:status => 200,
                  :headers => { "Content-Type" => "application/json" },
                  :body => File.open(SPEC_ROOT + '/fixtures/location.json'))
  end
end
