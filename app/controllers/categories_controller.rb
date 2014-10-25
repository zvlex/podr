class CategoriesController < ApplicationController
  before_action :verify_access, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = current_user.categories
  end

  def show
    @category = current_user.categories.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def edit
    @category = current_user.categories.find(params[:id])
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = 'Category created'
      redirect_to @category
    else
      render 'new'
    end
  end

  def update
    @category = current_user.categories.find(params[:id])
    if @category.update(category_params)
      flash[:success] = 'Category updated'
      redirect_to @category
    else
      render 'edit'
    end
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

private
  def category_params
    params.require(:category).permit(:title, :description)
  end

  def verify_access
    @category = current_user.categories.find_by_id(params[:id])
    redirect_to categories_path if @category.nil?
  end
end
