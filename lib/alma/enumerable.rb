# frozen_string_literal: true

require "forwardable"

module Alma::Enumerable
  extend ::Forwardable

  def self.included(mod)
    alias list each
    def_delegators :each, :each_with_index
  end

  def initialize(response_body_hash)
    @response = response_body_hash
  end

  def each
    @response.fetch(key, []).map { |item| Alma::AlmaRecord.new(item) }
  end
end
