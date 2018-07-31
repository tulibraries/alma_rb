# frozen_string_literal: true

require "forwardable"

class Alma::Enumerable
  extend ::Forwardable
  include Enumerable

  def_delegators :each, :each_with_index, :size

  def initialize(response_body_hash)
    @response = response_body_hash
  end

  def each
    @response.fetch(key, []).map { |item| Alma::AlmaRecord.new(item) }
  end
end
