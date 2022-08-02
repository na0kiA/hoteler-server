class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
end
