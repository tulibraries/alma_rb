$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "alma"
require 'pry'
require 'webmock/rspec'

SPEC_ROOT = File.dirname __FILE__

RSpec.configure do |config|
  config.before(:each) do

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

    # Request bibs info
    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/multiple_bibs.xml').read,
                  :headers => { 'content-type' => ['application/xml;charset=UTF-8']})

    stub_request(:get, /.*\.exlibrisgroup\.com\/almaws\/v1\/bibs/).
        with(query: hash_including({expand: 'p_avail,e_avail,d_avail', mms_id: '1,2' })).
        to_return(:status => 200,
                  :body => File.open(SPEC_ROOT + '/fixtures/availability_response.xml').read,
                  :headers => { 'content-type' => ['application/xml;charset=UTF-8']})

  end
end
