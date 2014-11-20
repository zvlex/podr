require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
  let(:category) { create(:category, user_id: @user.id) }

  before(:each) { create_user_and_sign_in }

  def create_user_and_sign_in
    @user = build(:user)
    @user.save(validate: false)
    sign_in(@user)
  end

  describe "GET #index" do
    before(:each) { get :index }

    it "shows list of categories" do
      expect(assigns(:categories)).to match_array([category])
    end

    it "render the :index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before(:each) { get :show, id: category }

    it "assigns the requested category to category" do
      expect(assigns(:category)).to eq(category)
    end

    it "render the :show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before(:each) { get :new }

    it "assigns a new Category to category" do
      expect(assigns(:category)).to be_a_new(Category)
    end

    it "render the :new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    before(:each) { get :edit, id: category }

    it "assigns the requested category to category" do
      expect(assigns(:category)).to eq(category)
    end

    it "render the :edit template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new category in the database" do
        expect{
          post :create, category: attributes_for(:category)
        }.to change(Category, :count).by(1)
      end

      it "redirects to the category page" do
        post :create, category: attributes_for(:category)
        expect(response).to redirect_to(assigns(:category))
      end

      it "shows a flash success message" do
        post :create, category: attributes_for(:category)
        expect(flash[:success]).to_not be_nil
      end 
    end

    context "with invalid attributes" do
      it "does not save new category in the database" do
        expect{
          post :create, category: attributes_for(:invalid_category)
        }.to_not change(Category, :count)
      end

      it "re-renders the :new template" do
        post :create, category: attributes_for(:invalid_category)
        expect(response).to render_template(:new)
      end  
    end
  end

  describe "PUT #update" do
    it "locates the requested @category" do
      put :update, id: category, category: attributes_for(:category)
      expect(assigns(:category)).to eq(category)
    end

    context "with valid attributes" do
      it "changes @category attributes" do
        put :update, id: category,
          category: attributes_for(:category, title: 'Linux', description: 'UbuntuMate')
        category.reload
        expect(category.title).to eq('Linux')
        expect(category.description).to eq('UbuntuMate')
      end

      it "redirects to the updated category" do
        put :update, id: category, category: attributes_for(:category)
        expect(response).to redirect_to(category)
      end
    end

    context "with invalid attributes" do
      it "does not changes category attributes" do
        put :update, id: category, 
          category: attributes_for(:category, title: nil, description: nil)
        expect(category.title).to_not eq(nil)
        expect(category.description).to_not eq(nil)
      end

      it "re-renders the :edit template" do
        put :update, id: category,
          category: attributes_for(:invalid_category)
        expect(response).to render_template(:edit)
      end   
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @category = create(:category, user_id: @user.id)
    end

    it "deletes the category" do
      expect{
        delete :destroy, id: @category
      }.to change(Category, :count).by(-1)
    end

    it "redirects to categories#index" do
      delete :destroy, id: @category
      expect(response).to redirect_to categories_url
    end
  end
end
