class TagsController < ApplicationController
  # get /photos/photo_id/tags/new
  def new
    begin
      @tag   = Tag.new
      @users = User.all
      @photo = Photo.find( params[:photo_id] )
      @title = "Tag #{@photo.user.full_name}'s photo"
    
    rescue ActiveRecord::RecordNotFound # catch invalid photo ID
      render_404
    end
  end

  # get /photos/photo_id/tags
  def index
    begin
      @photo = Photo.find( params[:photo_id] )
      @tags  = @photo.tags
      @title = "Tagged users for #{@photo.user.full_name}'s photo"
      
    rescue ActiveRecord::RecordNotFound # catch invalid photo ID
      render_404
    end
  end

  # post /photos/photo_id/tags 
  def create
    @title = "New tag validation"
    @tag   = Tag.create( valid_params(params) )
    if @tag.valid? then
      flash[:notice] = "New tag made for #{@tag.user.full_name}"
      redirect_to photo_tags_path(@tag.photo)
    else
      @photo = Photo.find( params[:photo_id] )
      @users = User.all
      render action: "new"
    end
  end

  private 
  # valid parameters for new/modificationss of comments
  def valid_params(params)
    params.permit(:user_id, :photo_id, :originX, :originY, :width, :height)
  end
end
