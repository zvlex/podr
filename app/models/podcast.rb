class Podcast < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :feed_items, dependent: :destroy
  
  validates :url, :category_id, presence: true
  validates :url, url: true, length: { minimum: 9 }
end
