class Comment < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user

  validates :comment, length: { minimum: 1, message: "cannot be empty" }
  validates :user_id, presence: true
  validates :date_time, presence: true
  validates :photo_id, presence: true
end
