class Tag < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user

  validates :user_id,  presence: true
  validates :photo_id, presence: true
  validates_numericality_of :originX, :greater_than_or_equal_to => 0
  validates_numericality_of :originY, :greater_than_or_equal_to => 0
  validates_numericality_of :width,   :greater_than_or_equal_to => 0
  validates_numericality_of :height,  :greater_than_or_equal_to => 0
end
