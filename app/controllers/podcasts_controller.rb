class PodcastsController < ApplicationController
  def index; end

  def show; end

  def new
    @podcast = Podcast.new
  end

  def edit
  end

  def create
    @podcast = FetchPodcast.new(podcast_params).fetch_podcast_info
    if @podcast.valid?
      flash[:success] = 'Successfully added'
      redirect_to @podcast
    else
      render 'new'
    end
  end

  def update
    @podcast = Podcast.find(params[:id])
    if @podcast.update(podcast_params)
      flash[:success] = 'Successfully updated'
      redirect_to @podcast
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
    def podcast_params
      params.require(:podcast).permit(:url, :category_id)
    end
end
