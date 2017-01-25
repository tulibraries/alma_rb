module Alma
  class BibSet < ResultSet

    def top_level_key
      'bibs'
    end

    def response_records_key
      'bib'
    end

    def single_record_class
      Alma::Bib
    end

    # Doesn't seem to actually return a total record count as documented.
    def total_record_count
      (response_records.is_a? Array) ? size : 1
    end

  end
end
