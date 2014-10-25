class Podcast < ActiveRecord::Base
  belongs_to :category
  
  validates :url, :category_id, presence: true
  validates :url, url: true, length: { minimum: 9 }
end
