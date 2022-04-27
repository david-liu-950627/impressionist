require 'spec_helper'

describe Impressionist::SetupAssociation do
  let(:mock)  { spy('receiver') }
  let(:set_up) { Impressionist::SetupAssociation.new(mock) }

  describe "attr_accessible" do
    it "includes" do
      allow(set_up).to receive(:toggle).and_return(true)
      set_up.include_attr_acc?
      expect(mock).to have_received(:attr_accessible).with(*([kind_of(Symbol)] * 12))
    end
  end

  describe "belongs_to" do
    it "active_record" do
      set_up.define_belongs_to
      expect(mock).to have_received(:belongs_to).with(:impressionable, hash_including(optional: true, polymorphic: true))
    end
  end

  describe "#set" do
    it "sets an association" do
      allow(set_up).to receive(:include_attr_acc?).and_return(true)
      allow(set_up).to receive(:define_belongs_to).and_return(true)

      expect(set_up.set).to be true
    end
  end
end
