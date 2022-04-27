require 'spec_helper'

describe Impressionist::RailsToggle do

  describe "Rails 4" do
    it "must not include attr_accessible" do
      allow(subject).to receive(:supported_by_rails?).and_return(false)
      expect(subject.should_include?).to be false
    end
  end

  describe "Strong Parameters" do
    it "must not include attr_accessible" do
      allow(subject).to receive(:supported_by_rails?).and_return(true)
      allow(subject).to receive(:using_strong_parameters?).and_return(true)
      expect(subject.should_include?).to be false
    end
  end
end
