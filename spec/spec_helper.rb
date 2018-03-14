$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "alma"
require 'pry'
require 'webmock/rspec'

SPEC_ROOT = File.dirname __FILE__

RSpec.configure do |config|
  config.before(:each) do

    WebMock.disable_net_connect!(allow: %r{https://api-na.hosted.exlibrisgroup.com/almaws/v1/bibs/991029347659703811/holdings/22240472680003811})

    # User details
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/single_user.json').read)

    #fees / fines
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/fees\/.*/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/fines.json'))

    # user requests
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/requests/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/requests.json'))

    # successful user authentication
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        with(query: hash_including({password: 'right_password'})).
        to_return(:status => 204)

    # failed user authentication
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*/).
        with(query: hash_including({password: 'wrong_password'})).
        to_return(:status => 400)

    # renew user loan
    stub_request(:post, /.*\.exlibrisgroup\.com\/almaws\/v1\/users\/.*\/loans\/.*/).
        with(query: hash_including({op: 'renew'})).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/renewal_success.json'))

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs\/.*\/holdings\/.*\/items/).
        to_return(:status => 200,
        :body => File.open(SPEC_ROOT + '/fixtures/bib_items.json'))

    # Request bibs info

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/multiple_bibs.json'))
  end
end
