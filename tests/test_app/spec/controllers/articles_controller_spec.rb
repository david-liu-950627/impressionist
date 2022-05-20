require 'spec_helper'

describe ArticlesController, type: :controller do
  fixtures :articles,:impressions,:posts,:widgets

  render_views

  it "should make the impressionable_hash available" do
    get "index"
    expect(response.body).to include("false")
  end

  it "should log an impression with a message" do
    get "index"
    expect(Impression.all.size).to eq 12
    expect(Article.first.impressions.last.message).to eq "this is a test article impression"
    expect(Article.first.impressions.last.controller_name).to eq "articles"
    expect(Article.first.impressions.last.action_name).to eq "index"
  end

  it "should log an impression without a message" do
    get "show", params: { id: 1 }
    expect(Impression.all.size).to eq 12
    expect(Article.first.impressions.last.message).to eq nil
    expect(Article.first.impressions.last.controller_name).to eq "articles"
    expect(Article.first.impressions.last.action_name).to eq "show"
  end

  it "should log the user_id if user is authenticated (@current_user before_action method)" do
    session[:user_id] = 123
    get "show", params: { id: 1 }
    expect(Article.first.impressions.last.user_id).to eq 123
  end

  it "should not log the user_id if user is authenticated" do
    get "show", params: { id: 1 }
    expect(Article.first.impressions.last.user_id).to eq nil
  end

  it "should log the request_hash, ip_address, referrer and session_hash" do
    get "show", params: { id: 1 }
    expect(Impression.last.request_hash.size).to eq 64
    expect(Impression.last.ip_address).to eq "0.0.0.0"
    expect(Impression.last.session_hash.size).to eq 32
    expect(Impression.last.referrer).to eq nil
  end

  # Capybara has change the way it works
  # We need to pass :type options in order to make include helper methods
  # see https://github.com/jnicklas/capybara#using-capybara-with-rspec
  it "should log the referrer when you click a link", :type => :feature do
    visit article_url(Article.first)
    click_link "Same Page"
    expect(Impression.last.referrer).to eq "http://test.host/articles/1"
  end

  it "should log request with params (checked = true)" do
    get "show", params: { id: 1, checked: true }
    expect(Impression.last.params).to eq({"checked"=> "true"})
    expect(Impression.last.request_hash.size).to eq 64
    expect(Impression.last.ip_address).to eq "0.0.0.0"
    expect(Impression.last.session_hash.size).to eq 32
    expect(Impression.last.referrer).to eq nil
  end

  it "should log request with params {}" do
    get "index"
    expect(Impression.last.params).to eq({})
    expect(Impression.last.request_hash.size).to eq 64
    expect(Impression.last.ip_address).to eq "0.0.0.0"
    expect(Impression.last.session_hash.size).to eq 32
    expect(Impression.last.referrer).to eq nil
  end

  describe "when filtering params" do
    before do
      @_filtered_params = Rails.application.config.filter_parameters
      Rails.application.config.filter_parameters = [:password]
    end

    it "values should not be recorded" do
      get "index", params: { password: "best-password-ever" }
      expect(Impression.last.params).to eq("password" => "[FILTERED]")
    end

    after do
      Rails.application.config.filter_parameters = @_filtered_params
    end
  end
end