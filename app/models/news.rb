class News < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :url, presence: true
  validates :source, presence: true
  validates :author, presence: true
  validates :published_at, presence: true
  validates :provider_id, presence: true
end
