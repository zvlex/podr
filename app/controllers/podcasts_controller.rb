class PodcastsController < ApplicationController
  before_action :verify_access, only: [:show, :edit, :update, :destroy]
  
  def index
    @podcasts = current_user.podcasts.order('created_at DESC')
  end

  def show
    @podcast = current_user.podcasts.find(params[:id])
    @feed_items = current_podcast.feed_items.order('published_at DESC').page(params[:page]).per(3)
  end

  def new
    @podcast = Podcast.new
  end

  def edit
    @podcast = current_user.podcasts.find(params[:id])
  end

  def create
    @podcast = FetchPodcast.new(podcast_params, current_user).fetch_podcast_info
    if @podcast.errors.any?
      render 'new'
    else
      flash[:success] = 'Successfully added'
      parse_entries
      redirect_to @podcast
    end
  end

  def change_status
    @podcast = FeedItem.find(params[:id])
    @podcast.listened = !@podcast.listened
    respond_to do |format|
      if @podcast.save
        format.js 
      end
    end
  end

  def check_for_new_items
    if ParseEntries.new(current_podcast.atom_link, current_podcast).entries
      redirect_to current_podcast
    end
  end

  def mark_as_listened
    current_pod = current_user.podcasts.find(params[:id])
    @pod = current_pod.feed_items.where(listened: false)
    @pod.each do |p|
      p.listened = true
      p.save 
    end
    redirect_to current_pod
  end

  def update
    @podcast = current_user.podcasts.find(params[:id])
    if @podcast.update(podcast_params)
      flash[:success] = 'Successfully updated'
      redirect_to @podcast
    else
      render 'edit'
    end
  end

  def destroy
    @podcast = current_user.podcasts.find(params[:id])
    @podcast.destroy
    redirect_to podcasts_path
  end

  private
    def podcast_params
      params.require(:podcast).permit(:url, :category_id)
    end

    def current_podcast
      if params[:id]
        current_user.podcasts.find(params[:id])
      else
        current_user.podcasts.find(@podcast.id)
      end
    end

    def parse_entries
      @entries = ParseEntries.new(@podcast.atom_link, current_podcast)
      @entries.entries
    end

    def verify_access
      @podcast = current_user.podcasts.find_by_id(params[:id])
      redirect_to podcasts_path if @podcast.nil?
    end
end
