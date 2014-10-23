require 'rails_helper'

RSpec.describe PodcastsController, :type => :controller do
  before(:each) do
    create_user_and_sign_in
  end

  def create_user_and_sign_in
    user = build(:user)
    user.save(validation: false)
    sign_in(user)
  end

  describe "GET #index" do
  end

  describe "GET #show" do
  end

  describe "GET #new" do
  end

  describe "GET #edit" do
  end
end
