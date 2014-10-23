class Podcast < ActiveRecord::Base
  belongs_to :category

  URI_REGEXP = /\A(http|https):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix
  
  validates :url, :category_id, presence: true
  validates :url, length: { minimum: 9 }, format: { with: URI_REGEXP }
end
