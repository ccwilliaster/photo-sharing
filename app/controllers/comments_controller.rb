class CommentsController < ApplicationController
  # get /photos/photo_id/comments/new
  def new
    begin
      @comment = Comment.new
      @photo   = Photo.find( params[:photo_id] )
      @title   = %Q|Comment on #{@photo.user.full_name}'s photo|

    rescue ActiveRecord::RecordNotFound # catch invalid photo ID
      render_404
    end
  end

  # post /photos/photo_id/comments
  def create
    params[:date_time] = DateTime.now
    params[:user_id]   = @curr_user.id
    @comment = Comment.create( valid_params(params) )

    if @comment.valid? then
      flash.notice = "Comment succesfully posted"
      redirect_to user_path(@comment.photo.user.id)
    else 
      @title = "Invalid comment"
      @photo = @comment.photo # I think this should have been params[:photo_id]
      render action: "new" # comment.errors passed
    end
  end

  private
  # Valid parameters for new/modification of comments
  def valid_params(params)
    params.permit(:date_time, :user_id, :photo_id, :comment)
  end
end
