class Category < ActiveRecord::Base
  belongs_to :user
  has_many :podcasts, dependent: :destroy

  validates :title, :description, presence: true
end
