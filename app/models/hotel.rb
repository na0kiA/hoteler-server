class Hotel < ApplicationRecord
  scope :accepted_hotel, -> { where(accepted: false) }

  belongs_to :user
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 2000 }
end
