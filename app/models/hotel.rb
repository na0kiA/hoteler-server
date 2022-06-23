class Hotel < ApplicationRecord
  scope :accepted_hotel, -> { where(accepted: false) }

  belongs_to :user
  validates :name, presence: true
  validates :content, presence: true
end
