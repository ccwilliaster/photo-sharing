class Photo < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  has_many   :tags

  validates_format_of :file_name,
    with: /\.(png|jpg|jpeg|tiff|bmp|gif)$/i,
    multiline: true,
    message: "extension must be a common image format" + 
             " (png, jpg, jpeg, tiff, bmp, gif)"
end
