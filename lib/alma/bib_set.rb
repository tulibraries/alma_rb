# frozen_string_literal: true

module Alma
  class BibSet < ResultSet
    def key
      "bib"
    end

    def single_record_class
      Alma::Bib
    end

    def total_record_count
      size
    end
  end
end
