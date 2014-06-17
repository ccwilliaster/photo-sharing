class PhotosController < ApplicationController
  # get /photos/search?query=...
  # ajax instant search
  def search
    @results = []

    # Search Photo comments and User names for any matches to the query (case-insensitive)
    unless params[:query].size == 0 
      @comments =  Comment.where(["comment LIKE ?", "%#{params[:query]}%"])
      @users    =  User.where(["first_name LIKE ? or last_name LIKE ?", 
                              "%#{params[:query]}%", "%#{params[:query]}%"])
      @comments.each { |comment| @results << comment.photo }
      @users.each do |user| 
        user.photos.each do |photo|
          @results << photo
        end
      end
    end
    @results = @results.uniq # no duplicates
    render :partial => "search"
  end
  
  # get /photos/new
  def new
    @title = "New photo upload"
    @photo = Photo.new
  end

  # post /photos/
  def create
    if params[:photo].nil? # check that a file is not empty
      flash[:notice] = "No photo chosen."
      redirect_to action: "new"
    else
      uploaded = params[:photo][:file_name]
      filename = uploaded.original_filename

      params[:user_id]   = @curr_user.id
      params[:file_name] = filename
      params[:date_time] = DateTime.now
      @photo = Photo.create( valid_params(params) ) 
      
      if @photo.valid? then
        upload_file(uploaded, filename)
        flash[:notice] = "New photo uploaded successfully"
        redirect_to user_path(@curr_user)
      else
        @title = "Photo upload error"
        render action: "new"
      end
    end
  end

  private
  # Helper function which copies a file to the local assets/images dir
  def upload_file(file, file_name)
    local_path = Rails.root.join("app", "assets", "images", file_name)
    File.open(local_path, "wb") do |local_file|
      local_file.write(file.read)
    end
  end

  # Valid photo parameters
  def valid_params(params)
    params.permit(:user_id, :file_name, :date_time)
  end
end
