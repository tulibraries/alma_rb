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
      digitization_normalization(args) if digitization_request?
    end

    def validate!(args)
      unless REQUEST_TYPES.include?(request_type)
        raise ArgumentError.new(":request_type option must be specified and one of #{REQUEST_TYPES.join(", ")} to submit a request")
      end
      digitization_validation(args) if digitization_request?
    end

    def digitization_request?
      request_type == "DIGITIZATION"
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
  end
end
