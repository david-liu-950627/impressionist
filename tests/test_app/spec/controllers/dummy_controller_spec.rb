require 'spec_helper'

describe DummyController, type: :controller do
  fixtures :impressions
  render_views

  it "should log impression at the per action level on non-restful controller" do
    get "index"
    expect(Impression.all.size).to eq 12
  end
end