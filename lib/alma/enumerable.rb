# frozen_string_literal: true

module Alma::Enumerable
  def self.included(mod)
    alias list each
    delegate :each_with_index, to: :each
  end

  def initialize(response_body_hash)
    @response = response_body_hash
  end

  def each
    @response.fetch(key, []).map { |item| Alma::AlmaRecord.new(item) }
  end
end
