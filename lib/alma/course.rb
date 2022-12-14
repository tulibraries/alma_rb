# frozen_string_literal: true

module Alma
  class Course
    extend Alma::ApiDefaults
    extend Forwardable

    def self.all_courses(args: {})
      response = HTTParty.get("#{courses_base_path}/courses",
                              query: args,
                              headers:,
                              timeout:)
      if response.code == 200
        Alma::CourseSet.new(get_body_from(response))
      else
        raise StandardError, get_body_from(response)
      end
    end

    attr_accessor :response

    # The Course object can respond directly to Hash like access of attributes
    def_delegators :response, :[], :[]=, :has_key?, :keys, :to_json

    def initialize(response_body)
      @response = response_body
    end

    private

      def self.get_body_from(response)
        JSON.parse(response.body)
      end

      def self.courses_base_path
        "https://api-na.hosted.exlibrisgroup.com/almaws/v1"
      end

      def courses_base_path
        self.class.courses_base_path
      end

      def headers
        self.class.headers
      end
  end
end
