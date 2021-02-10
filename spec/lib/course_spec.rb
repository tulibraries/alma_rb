require "spec_helper"

describe Alma::Course do
  before(:all) do
    Alma.configure
  end

  describe "#courses" do
    let(:courses){Alma::Course.all_courses}
    it 'responds' do
      expect(described_class).to respond_to :all_courses
    end

    it 'returns a CourseSet object' do
      expect(courses).to be_a Alma::CourseSet
    end

    it 'has courses in each' do
      expect(courses.each).to_not be_empty
      expect(courses.each).to be_kind_of Array
    end

    it 'responds to total_record_count' do
      expect(courses).to respond_to :total_record_count
    end
  end
end
