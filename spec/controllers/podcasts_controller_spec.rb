require 'rails_helper'

RSpec.describe PodcastsController, :type => :controller do
  let(:podcast) { create(:podcast, user_id: @user.id) }

  before(:each) { create_user_and_sign_in }

  def create_user_and_sign_in
    @user = build(:user)
    @user.save(validate: false)
    sign_in(@user)
  end

  describe "GET #index" do
    before(:each) { get :index }

    it "shows list of podcasts" do
      expect(assigns(:podcasts)).to match_array([podcast])
    end

    it "render the :index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before(:each) { get :show, id: podcast }

    it "assigns the requested podcast to podcast" do
      expect(assigns(:podcast)).to eq(podcast)
    end

    it "render the :show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before(:each) { get :new }

    it "assigns a new Podcast to podcast" do
      expect(assigns(:podcast)).to be_a_new(Podcast)
    end

    it "renders the :new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    before(:each) do
      pending "because the template is not created"
      get :edit, id: podcast
    end

    it "assigns the request podcast to podcast" do
      expect(assigns(:podcast)).to eq(podcast)
    end

    it "renders the :edit template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new podcast in the database" do
        pending "service object"
        expect{
          post :create, podcast: attributes_for(:podcast)
          }.to change(Podcast, :count).by(1)
      end

      it "redirects to podcast page" do
        pending "service object"
        post :create, podcast: attributes_for(:podcast)
        expect(response).to redirect_to(assigns(:podcast))
      end

      it "show flash success message" do
        pending "service object"
        post :create, podcast: attributes_for(:podcast)
        expect(flash[:success]).to_not be_nil
      end
    end

    context "with invalid attributes" do
      it "does nit save new podcast in the database" do
        expect{
          post :create, podcast: attributes_for(:invalid_podcast)
          }.to_not change(Podcast, :count)
      end

      it "re-renders the :new template" do
        post :create, podcast: attributes_for(:invalid_podcast)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
  end
end
