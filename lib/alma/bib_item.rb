require 'alma/bib_item_set'
module Alma
  class BibItem
    extend Alma::ApiDefaults
    extend Forwardable

    attr_reader :item
    def_delegators :item, :[], :has_key?, :keys, :to_json

    PERMITTED_ARGS  = [
      :limit, :offset, :expand, :user_id, :current_library,
      :current_location, :q, :order_by, :direction
    ]

    def self.find(mms_id, options={})
      holding_id = options.delete(:holding_id) || "ALL"
      options.select! {|k,_| PERMITTED_ARGS.include? k }
      url = "#{bibs_base_path}/#{mms_id}/holdings/#{holding_id}/items"
      response = HTTParty.get(url, headers: headers, query: options, timeout: timeout)
      BibItemSet.new(response, options.merge({mms_id: mms_id, holding_id: holding_id}))
    end

    def self.find_by_barcode(barcode)
      response = HTTParty.get(items_base_path, headers: headers, query: { item_barcode: barcode }, timeout: timeout, follow_redirects: true)
      new(response)
    end

    def initialize(item)
      @item = item
    end

    def holding_data
      @item.fetch("holding_data", {})
    end

    def item_data
      @item.fetch("item_data", {})
    end

    def in_temp_location?
      holding_data.fetch("in_temp_location", false)
    end

    def library
      in_temp_location? ? temp_library : holding_library
    end

    def library_name
      in_temp_location? ? temp_library_name : holding_library_name
    end

    def location
      in_temp_location? ? temp_location : holding_location
    end

    def location_name
      in_temp_location? ? temp_location_name : holding_location_name
    end

    def holding_library
      item_data.dig("library", "value")
    end

    def holding_library_name
      item_data.dig("library", "desc")
    end

    def holding_location
      item_data.dig("location", "value")
    end

    def holding_location_name
      item_data.dig("location", "desc")
    end

    def temp_library
      holding_data.dig("temp_library", "value")
    end

    def temp_library_name
      holding_data.dig("temp_library", "desc")
    end

    def temp_location
      holding_data.dig("temp_location", "value")
    end

    def temp_location_name
      holding_data.dig("temp_location", "desc")
    end

    def temp_call_number
      holding_data.fetch("temp_call_number","")
    end

    def has_temp_call_number?
      !temp_call_number.empty?
    end

    def call_number
      if has_temp_call_number?
        holding_data.fetch("temp_call_number")
      else
        holding_data.fetch("call_number","")
      end
    end

    def has_alt_call_number?
      !alt_call_number.empty?
    end

    def alt_call_number
      item_data.fetch("alternative_call_number","")
    end

    def has_process_type?
      !process_type.empty?
    end

    def process_type
      item_data.dig("process_type", "value") || ""
    end

    def missing_or_lost?
      !!process_type.match(/MISSING|LOST_LOAN/)
    end

    def base_status
      item_data.dig("base_status","value")|| ""
    end

    def in_place?
      base_status == "1"
    end

    def circulation_policy
      item_data.dig("policy", "desc") || ""
    end

    def non_circulating?
      circulation_policy.include?("Non-circulating")
    end

    def description
      item_data.fetch("description", "")
    end

    def physical_material_type
      item_data.fetch("physical_material_type", "")
    end

    def public_note
      item_data.fetch("public_note", "")
    end
  end
end
