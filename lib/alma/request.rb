module Alma
  class BibRequest
    extend Alma::ApiDefaults

    REQUEST_TYPES = %w[HOLD DIGITIZATION BOOKING]

    def self.submit(args)
      request = new(args)
      response = HTTParty.post(
        "#{bibs_base_path}/#{request.mms_id}/requests",
        query: {user_id: request.user_id},
        headers: headers,
        body: request.body.to_json
        )
        Alma::Response.new(response)
    end

    attr_reader :mms_id, :user_id, :body, :request_type
    def initialize(args)
      @mms_id = args.delete(:mms_id) { raise ArgumentError.new(":mms_id option must be specified to create request") }
      @user_id = args.delete(:user_id) { raise ArgumentError.new(":user_id option must be specified to create request") }
      @request_type = args.fetch(:request_type, "NOT_SPECIFIED")
      validate!(args)
      normalize!(args)
      @body = args
    end


    def normalize!(args)
      request_type_normalization!(args)
      additional_normalization!(args)
    end

    def request_type_normalization!(args)
      method = "#{@request_type.downcase}_normalization".to_sym
      send(method, args) if respond_to? method
    end

    # Intended to be overridden by subclasses, allowing extra normalization logic to be provided
    def additional_normalization!(args)
    end

    def validate!(args)
      unless REQUEST_TYPES.include?(request_type)
        raise ArgumentError.new(":request_type option must be specified and one of #{REQUEST_TYPES.join(", ")} to submit a request")
      end
      request_type_validation!(args)
      additional_validation!(args)
    end

    def request_type_validation!(args)
      method = "#{@request_type.downcase}_validation".to_sym
      send(method, args) if respond_to? method
    end

    # Intended to be overridden by subclasses, allowing extra validation logic to be provided
    def additional_validation!(args)
    end

    def digitization_normalization(args)
      if args[:target_destination].is_a? String
        args[:target_destination] = { value: args[:target_destination] }
      end
    end

    def digitization_validation(args)
      args.fetch(:target_destination) do
        raise ArgumentError.new(
        ":target_destination option must be specified when request_type is DIGITIZATION"
        )
      end
      pd = args.fetch(:partial_digitization) do
        raise ArgumentError.new(
        ":partial_digitization option must be specified when request_type is DIGITIZATION"
        )
      end
      if pd == true
        args.fetch(:comment) do
          raise ArgumentError.new(
          ":comment option must be specified when :request_type is DIGITIZATION and :partial_digitization is true"
          )
        end
      end
    end

    def booking_normalization(args)
      if args[:material_type].is_a? String
        args[:material_type] = { value: args[:material_type] }
      end
    end

    def booking_validation(args)
      args.fetch(:booking_start_date) do
        raise ArgumentError.new(
        ":booking_start_date option must be specified when request_type is BOOKING"
        )
      end
      args.fetch(:booking_end_date) do
        raise ArgumentError.new(
        ":booking_end_date option must be specified when request_type is BOOKING"
        )
      end
      args.fetch(:pickup_location_type) do
        raise ArgumentError.new(
        ":pickup_location_type option must be specified when request_type is BOOKING"
        )
      end
      args.fetch(:pickup_location_library) do
        raise ArgumentError.new(
        ":pickup_location_library option must be specified when request_type is BOOKING"
        )
      end
    end

    def hold_normalization(args)
      # if args[:material_type].is_a? String
      #   args[:material_type] = { value: args[:material_type] }
      # end
    end

    def hold_validation(args)
      args.fetch(:pickup_location_type) do
        raise ArgumentError.new(
        ":pickup_location_type option must be specified when request_type is HOLD"
        )
      end
      args.fetch(:pickup_location_library) do
        raise ArgumentError.new(
        ":pickup_location_library option must be specified when request_type is HOLD"
        )
      end
    end
  end

  class ItemRequest < BibRequest
    def self.submit(args)
      request = new(args)
      response = HTTParty.post(
        "#{bibs_base_path}/#{request.mms_id}/holdings/#{request.holding_id}/items/#{request.item_pid}/requests",
        query: {user_id: request.user_id},
        headers: headers,
        body: request.body.to_json
        )
        Alma::Response.new(response)
    end

    attr_reader :holding_id, :item_pid
    def initialize(args)
      super(args)
      @holding_id = args.delete(:holding_id) { raise ArgumentError.new(":holding_id option must be specified to create request") }
      @item_pid = args.delete(:item_pid) { raise ArgumentError.new(":item_pid option must be specified to create request") }
    end

    def additional_validation!(args)
      args.fetch(:description) do
        raise ArgumentError.new(
        ":description option must be specified when request_type is DIGITIZATION"
        )
      end
    end
  end
end
