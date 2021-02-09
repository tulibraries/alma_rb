# frozen_string_literal: true

module Alma
  class CourseSet < ResultSet
    def key
      "course"
    end

    def single_record_class
      Alma::Course
    end

    def total_record_count
      size
    end
  end
end
