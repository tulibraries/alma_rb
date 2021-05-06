# frozen_string_literal: true

require "spec_helper"

describe Alma::BibRequest do
  before(:all) do
    Alma.configure
  end

  context "#submit" do
    it "is responded to" do
      expect(described_class).to respond_to :submit
    end

    context "when required options are missing " do
      it "raises an Error when mms_id is not an included option" do
        expect { described_class.submit({}) }.to raise_error(ArgumentError, /:mms_id option/)
      end

      it "raises an Error when user_id is not an included option" do
        expect { described_class.submit({ mms_id: "foo" }) }.to raise_error(ArgumentError, /:user_id option/)
      end

      it "raises an Error when request_type is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user" }) }.to raise_error(ArgumentError, /:request_type option/)
      end

      it "raises an Error when the request_type is not valid" do
        options = { mms_id: "foo", user_id: "user", request_type: "invalid" }
        expect { described_class.submit(options) }.to raise_error(ArgumentError, /:request_type option/)
      end

      it "raises an Error when pickup_location_library is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "HOLD", pickup_location_type: "LIBRARY" }) }.to raise_error(ArgumentError, /:pickup_location_library option/)
      end

      it "raises an Error when booking_start_date is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "BOOKING", booking_end_date: "7/20/18" }) }.to raise_error(ArgumentError, /:booking_start_date option/)
      end

      it "raises an Error when booking_end_date is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "BOOKING", booking_start_date: "7/20/18" }) }.to raise_error(ArgumentError, /:booking_end_date option/)
      end

      it "raises an Error when target_destination is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "DIGITIZATION" }) }.to raise_error(ArgumentError, /:target_destination option/)
      end

      it "raises an Error when partial_digitization is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "DIGITIZATION", target_destination: "target" }) }.to raise_error(ArgumentError, /:partial_digitization option/)
      end

      it "raises an Error when comments is not an included option when partial digitization is true" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user", request_type: "DIGITIZATION", target_destination: "target", partial_digitization: true }) }.to raise_error(ArgumentError, /:comment option/)
      end


    end

    context "digitization requests" do
      let(:base_options) { { mms_id: "foo", user_id: "user" } }

      context "when it receives required options" do
        let(:submit_request) do
          described_class.submit(base_options.merge(
                                   {
                                     request_type: "DIGITIZATION",
                                     target_destination: "DIGI_DEPT_INST",
                                     partial_digitization: false
                                   }
          ))
        end

        it "sends a post to the expected url" do
          submit_request
          expect(WebMock).to have_requested(:post, /.*\/bibs\/foo/)
            .with(
              query: hash_including({ user_id: "user" }),
              body: hash_including({ request_type: "DIGITIZATION", partial_digitization: false })
            )
        end

        it "returns a request_response object" do
          expect(submit_request).to be_a Alma::Response
        end

        it "was sucessful" do
          expect(submit_request.success?).to be true
        end
      end
    end

    context "hold requests" do
      let(:base_options) { { mms_id: "foo", user_id: "user" } }

      context "when it receives required options" do
        let(:submit_request) do
          described_class.submit(base_options.merge(
                                   {
                                     request_type: "HOLD",
                                     pickup_location_type: "LIBRARY",
                                     pickup_location_library: "MAIN"
                                   }
          ))
        end

        it "sends a post to the expected url" do
          submit_request
          expect(WebMock).to have_requested(:post, /.*\/bibs\/foo/)
            .with(
              query: hash_including({ user_id: "user" }),
              body: hash_including({ request_type: "HOLD" })
            )
        end

        it "returns a request_response object" do
          expect(submit_request).to be_a Alma::Response
        end

        it "was sucessful" do
          expect(submit_request.success?).to be true
        end
      end
    end

    context "booking requests" do
      let(:base_options) { { mms_id: "foo", user_id: "user" } }

      context "when it receives required options" do
        let(:submit_request) do
          described_class.submit(base_options.merge(
                                   {
                                     request_type: "BOOKING",
                                     pickup_location_type: "LIBRARY",
                                     pickup_location_library: "MAIN",
                                     booking_start_date: "7-20-18",
                                     booking_end_date: "7-27-18"
                                   }
          ))
        end

        it "sends a post to the expected url" do
          submit_request
          expect(WebMock).to have_requested(:post, /.*\/bibs\/foo/)
            .with(
              query: hash_including({ user_id: "user" }),
              body: hash_including({ request_type: "BOOKING" })
            )
        end

        it "returns a request_response object" do
          expect(submit_request).to be_a Alma::Response
        end

        it "was sucessful" do
          expect(submit_request.success?).to be true
        end
      end
    end
  end
end

describe Alma::ItemRequest do
  before(:all) do
    Alma.configure
  end

  context "#submit" do
    it "is responded to" do
      expect(described_class).to respond_to :submit
    end

    context "when required options are missing " do
      it "raises an Error when mms_id is not an included option" do
        expect { described_class.submit({}) }.to raise_error(ArgumentError, /:mms_id option/)
      end

      it "raises an Error when user_id is not an included option" do
        expect { described_class.submit({ mms_id: "foo" }) }.to raise_error(ArgumentError, /:user_id option/)
      end

      it "raises an Error when description is not an included option" do
        options = { mms_id: "foo", holding_id: "hold", item_pid: "pid", user_id: "user", request_type: "DIGITIZATION", target_destination: "DIGI_DEPT_INST", partial_digitization: false }
        expect { described_class.submit(options) }.to raise_error(ArgumentError, /:description option/)
      end

      it "raises an Error when request_type is not an included option" do
        expect { described_class.submit({ mms_id: "foo", user_id: "user" }) }.to raise_error(ArgumentError, /:request_type option/)
      end

      it "raises an Error when the request_type is not valid" do
        options = { mms_id: "foo", user_id: "user", request_type: "invalid" }
        expect { described_class.submit(options) }.to raise_error(ArgumentError, /:request_type option/)
      end
    end

    context "digitization requests" do
      let(:base_options) { { mms_id: "foo", holding_id: "hold", item_pid: "pid", user_id: "user" } }

      context "when it receives required options" do
        let(:submit_request) do
          described_class.submit(base_options.merge(
                                   {
                                     request_type: "DIGITIZATION",
                                     target_destination: "DIGI_DEPT_INST",
                                     partial_digitization: false,
                                     description: "desc"
                                   }
          ))
        end

        it "sends a post to the expected url" do
          submit_request
          expect(WebMock).to have_requested(:post, /.*\/bibs\/foo\/holdings\/hold\/items\/pid\/requests/)
            .with(
              query: hash_including({ user_id: "user" }),
              body: hash_including({ request_type: "DIGITIZATION", partial_digitization: false, description: "desc" })
            )
        end

        it "returns a request_response object" do
          expect(submit_request).to be_a Alma::Response
        end

        it "was sucessful" do
          expect(submit_request.success?).to be true
        end
      end
    end
  end
end
