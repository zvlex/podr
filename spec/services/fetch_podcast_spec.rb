require 'rails_helper'

RSpec.describe FetchPodcast, :type => :service do
  let(:host) { 'http://rubynoname.ru' }
  let(:category_id) { 1 }

  before(:each) do
    @podcast = FetchPodcast.new(
      { 
        url: host,
        category_id: category_id
      },
      @user = build(:user)
      )
  end

  it "should response uri" do
    response = @podcast.response_uri(host) 
    expect(response).not_to be nil
  end
end
